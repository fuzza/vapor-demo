import Vapor
import HTTP
import AuthProvider

final class TasksController {
  /// GET /tasks
  /// Returns [Task]
  func index(req: Request) throws -> ResponseRepresentable {
    return try Task.all().makeJSON()
  }
  
  /// POST /tasks
  /// returns Task
  func create(request: Request) throws -> ResponseRepresentable {
    guard let json = request.json else {
      throw Abort.badRequest
    }
    
    let currentUser = try request.auth.assertAuthenticated(User.self)
    
    guard let title = json[Task.Keys.title]?.string,
          let body = json[Task.Keys.body]?.string,
          let assigneeId = json[Task.Keys.assignee]?.int,
          let assignee = try User.find(assigneeId) else {
        throw Abort.badRequest
    }
    
    let task = try Task(title: title,
                        body: body,
                        author: currentUser,
                        assignee: assignee)
    try task.save()
    return task
  }
}

extension TasksController: ResourceRepresentable {
  func makeResource() -> Resource<Task> {
    return Resource(index: index, store: create)
  }
}

extension TasksController: EmptyInitializable {}
