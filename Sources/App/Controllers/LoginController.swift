import Vapor
import HTTP
import AuthProvider
import FluentProvider

final class LoginController {
  /// POST /login
  /// returns token
  func create(request: Request) throws -> ResponseRepresentable {
    let user = try request.auth.assertAuthenticated(User.self)
    let token = try AuthToken(user: user)
    try token.save()
    return token
  }
}

extension LoginController: ResourceRepresentable {
  func makeResource() -> Resource<AuthToken> {
    return Resource(store: create)
  }
}

extension LoginController: EmptyInitializable {}
