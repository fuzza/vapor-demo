import Vapor
import HTTP

final class UsersController {
  /// GET /users
  /// Returns [User]
  func index(req: Request) throws -> ResponseRepresentable {
    return try User.all().makeJSON()
  }
}

extension UsersController: ResourceRepresentable {
  func makeResource() -> Resource<User> {
    return Resource(index: index)
  }
}

extension UsersController: EmptyInitializable {}
