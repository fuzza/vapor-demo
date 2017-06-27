import Vapor

extension Droplet {
  func setupRoutes() throws {
    try resource("signup", SignupController.self)
    try resource("users", UsersController.self)
  }
}
