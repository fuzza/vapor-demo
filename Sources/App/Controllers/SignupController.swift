import Vapor
import HTTP
import FluentProvider

final class SignupController {
  
  /// POST /signup
  func create(request: Request) throws -> ResponseRepresentable {
    
    guard let json = request.json else {
      throw Abort(.unprocessableEntity)
    }
    
    let name: String = try json.get("username")
    let password: String = try json.get("password")
    
    let userOpt = try User.makeQuery().filter(User.Keys.userName, .equals, name).first()
    guard let user = userOpt else {
      throw Abort.notFound
    }
    
    guard user.password == password else {
      throw Abort.unauthorized
    }
    
    let token = AuthToken(userId: user.id!)
    return token
  }
}

extension SignupController: ResourceRepresentable {
  func makeResource() -> Resource<AuthToken> {
    return Resource(store: create)
  }
}

extension SignupController: EmptyInitializable {}
