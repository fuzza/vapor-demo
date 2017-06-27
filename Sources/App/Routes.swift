import Vapor
import AuthProvider

extension Droplet {
  func setupRoutes() throws {
    try setupUnprotectedRoutes()
    try setupPasswordProtectedRoutes()
    try setupTokenProtectedRoutes()
  }
  
  private func setupUnprotectedRoutes() throws {
    try resource("signup", SignupController.self)
  }
  
  private func setupPasswordProtectedRoutes() throws {
    let passwordMiddleware = PasswordAuthenticationMiddleware(User.self)
    let passwordGroup = self.grouped(passwordMiddleware)
    try passwordGroup.resource("login", LoginController.self)
  }
  
  private func setupTokenProtectedRoutes() throws {
    let tokenMiddleware = TokenAuthenticationMiddleware(User.self)
    let tokenGroup = self.grouped(tokenMiddleware)
    try tokenGroup.resource("users", UsersController.self)
  }
}
