import Foundation

public protocol DataFetchRequest {

  /// Request data type
  associatedtype FetchData
  
  associatedtype FetchError: Error = Error
  
  /// Request completion closure
  typealias FetchCompletion = (Result<FetchData, FetchError>) -> Void

  /// Execute request
  /// - Parameter completion: completion block
  @discardableResult
  func run(completion: @escaping FetchCompletion) -> Cancellable
  
  func eraseToAny() -> AnyFetchRequest<FetchData, FetchError>
}
