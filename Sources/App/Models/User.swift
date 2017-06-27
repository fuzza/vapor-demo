import Vapor
import FluentProvider

final class User: Model {
  
  let storage = Storage()
  
  var userName: String
  var email: String
  var password: String
  var firstName: String?
  var lastName: String?
  
  init(userName: String,
       email: String,
       password: String,
       firstName: String? = nil,
       lastName: String? = nil) {
    self.userName = userName
    self.email = email
    self.password = password
    self.firstName = firstName
    self.lastName = lastName
  }

  init(row: Row) throws {
    userName = try row.get(Keys.userName)
    email = try row.get(Keys.email)
    password = try row.get(Keys.password)
    firstName = try row.get(Keys.firstName)
    lastName = try row.get(Keys.lastName)
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Keys.userName, userName)
    try row.set(Keys.email, email)
    try row.set(Keys.password, password)
    try row.set(Keys.firstName, firstName)
    try row.set(Keys.lastName, lastName)
    return row
  }
}

extension User {
  struct Keys {
    static let id = "id"
    static let email = "email"
    static let userName = "userName"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let password = "password"
  }
}

extension User: Preparation {
  static func prepare(_ database: Database) throws {
    try database.create(self) { users in
      users.id()
      users.string(Keys.userName, unique: true)
      users.string(Keys.email, unique: true)
      users.string(Keys.password)
      users.string(Keys.firstName, optional: true)
      users.string(Keys.lastName, optional: true)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

extension User: JSONRepresentable {
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Keys.id, id)
    try json.set(Keys.email, email)
    try json.set(Keys.userName, userName)
    try json.set(Keys.firstName, firstName)
    try json.set(Keys.lastName, lastName)
    return json
  }
}

extension User: ResponseRepresentable { }

class UserPrefill: Preparation {
  static func prepare(_ database: Database) throws {
    let user = User.init(userName: "alfa",
                         email: "alfa@ciklum.com",
                         password: "12345678")
    try user.save()
  }
  
  static func revert(_ database: Database) throws {
    // do nothing
  }
}

