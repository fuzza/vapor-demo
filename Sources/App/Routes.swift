import Vapor
import AuthProvider

public enum Resources: String {
  case login
  case signup
  case users
}

extension Droplet {
  func setupRoutes() throws {
    try setupUnprotectedRoutes()
    try setupPasswordProtectedRoutes()
    try setupTokenProtectedRoutes()
  }
  
  private func setupUnprotectedRoutes() throws {
    try resource(Resources.signup.rawValue, SignupController.self)
  }
  
  private func setupPasswordProtectedRoutes() throws {
    let passwordMiddleware = PasswordAuthenticationMiddleware(User.self)
    let passwordGroup = self.grouped(passwordMiddleware)
    try passwordGroup.resource(Resources.login.rawValue, LoginController.self)
  }
  
  private func setupTokenProtectedRoutes() throws {
    let tokenMiddleware = TokenAuthenticationMiddleware(User.self)
    let tokenGroup = self.grouped(tokenMiddleware)
    try tokenGroup.resource(Resources.users.rawValue, UsersController.self)
  }
}
