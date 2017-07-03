import Vapor
import FluentProvider

final class Task: Model, Timestampable {
  let storage = Storage()
  
  var title: String
  var body: String
  
  var authorId: Identifier
  var assigneeId: Identifier
  
  var author: Parent<Task, User> {
    return parent(id: authorId)
  }
  
  var assignee: Parent<Task, User> {
    return parent(id: assigneeId)
  }
  
  init(title: String,
       body: String,
       author: User,
       assignee: User) throws {
    self.title = title
    self.body = body
    self.authorId = try author.assertExists()
    self.assigneeId = try assignee.assertExists()
  }
    
  init(row: Row) throws {
    title = try row.get(Keys.title)
    body = try row.get(Keys.body)
    authorId = try row.get(Keys.authorId)
    assigneeId = try row.get(Keys.assigneeId)
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.title, title)
    try row.set(Keys.body, body)
    try row.set(Keys.authorId, authorId)
    try row.set(Keys.assigneeId, assigneeId)
    return row
  }
}

// MARK: Database preparation

extension Task: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self) { tasks in
      tasks.id()
      tasks.string(Keys.title)
      tasks.string(Keys.body)
      tasks.foreignId(for: User.self, foreignIdKey: Keys.authorId)
      tasks.foreignId(for: User.self, foreignIdKey: Keys.assigneeId)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: JSON serialization/deserialization

extension Task: JSONRepresentable {
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.title, title)
    try json.set(Keys.body, body)
    try json.set(Keys.author, author.get())
    try json.set(Keys.assignee, assignee.get())
    return json
  }
}

extension Task: ResponseRepresentable { }

// MARK: Keypaths helpers

extension Task {
  struct Keys {
    static let id = "id"
    static let title = "title"
    static let body = "body"
    static let authorId = "authorId"
    static let assigneeId = "assigneeId"
    static let author = "author"
    static let assignee = "assignee"
  }
}
