import Vapor
import FluentProvider

final class AuthToken: Model {
  let storage = Storage()
  
  let userId: Identifier
  let token: String
  
  init(userId: Identifier) {
    self.token = UUID().uuidString
    self.userId = userId
  }
  
  var user: Parent<AuthToken, User> {
    return parent(id: userId)
  }
  
  init(row: Row) throws {
    userId = try row.get(Keys.userId)
    token = try row.get(Keys.token)
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.userId, userId)
    try row.set(Keys.token, token)
    return row
  }
}

extension AuthToken {
  struct Keys {
    static let id = "id"
    static let userId = "userId"
    static let token = "token"
  }
}

extension AuthToken: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self) { tokens in
      tokens.id()
      tokens.string(Keys.token)
      tokens.foreignId(for: User.self)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension AuthToken: JSONRepresentable {
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.token, token)
    return json
  }
}

extension AuthToken: ResponseRepresentable {}
