import Vapor
import HTTP
import AuthProvider
import FluentProvider
import VaporValidation

final class SignupController {
  /// POST /signup
  /// returns user
  func create(request: Request) throws -> ResponseRepresentable {
    guard let json = request.json else {
      throw Abort.badRequest
    }
    
    try json[User.Keys.email]?.string?.validated(by: EmailValidator())
    
    let user = try User(json: json)
    try user.save()
    return user
  }
}

extension SignupController: ResourceRepresentable {
  func makeResource() -> Resource<User> {
    return Resource(store: create)
  }
}

extension SignupController: EmptyInitializable {}
