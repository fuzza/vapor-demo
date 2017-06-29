import Vapor
import HTTP
import AuthProvider
import FluentProvider

final class LogoutController {
  /// POST /logout
  /// invalidates and removes token from database
  func create(request: Request) throws -> ResponseRepresentable {
    guard let header = request.auth.header?.string, let range = header.range(of: "Bearer ") else {
      throw Abort.unauthorized
    }
    let authToken = header.substring(from: range.upperBound)
    
    let token = try AuthToken.makeQuery()
      .filter(AuthToken.Keys.token, .equals, authToken.string)
      .first()
    
    guard let unwrappedToken = token else {
      throw Abort.notFound
    }
    
    try unwrappedToken.delete()
    try request.auth.unauthenticate()
    
    return Response(status: .ok)
  }
}

extension LogoutController: ResourceRepresentable {
  typealias Model = AuthToken

  func makeResource() -> Resource<AuthToken> {
    return Resource(store: create)
  }
}

extension LogoutController: EmptyInitializable {}
  
