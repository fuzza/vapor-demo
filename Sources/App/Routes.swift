import Vapor
import AuthProvider

extension Droplet {
  func setupRoutes() throws {
    let tokenMiddleware = TokenAuthenticationMiddleware(User.self)
    let auth = self.grouped(tokenMiddleware)
    try auth.resource("users", UsersController.self)

    try resource("signup", SignupController.self)
  }
}
