import AuthProvider
import FluentProvider

extension Config {
  public func setup() throws {
    Node.fuzzy = [Row.self, JSON.self, Node.self]
    
    try setupProviders()
    try setupPreparations()
  }
  
  private func setupProviders() throws {
    try addProvider(AuthProvider.Provider.self)
    try addProvider(FluentProvider.Provider.self)
  }
  
  private func setupPreparations() throws {
    preparations.append(User.self)
    preparations.append(AuthToken.self)
  }
}
