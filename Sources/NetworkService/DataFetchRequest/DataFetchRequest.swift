import Foundation

public protocol DataFetchRequest {
  /// Request query type
  associatedtype Query
  
  /// Request data type
  associatedtype FetchData
  
  associatedtype FetchError: Error = Error
  
  /// Request completion closure
  typealias FetchCompletion = (Result<FetchData, FetchError>) -> Void
  
  /// Request query
  var query: Query { get }
  
  /// Execute request
  /// - Parameter completion: completion block
  @discardableResult
  func run(completion: @escaping FetchCompletion) -> Cancellable
  
  func eraseToAny() -> AnyFetchRequest<Query, FetchData, FetchError>
}
