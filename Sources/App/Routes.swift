import Vapor

extension Droplet {
  func setupRoutes() throws {
    try resource("users", UsersController.self)
  }
}
