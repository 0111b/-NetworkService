import Foundation

extension DataFetchRequest {

  public func flatMap<MappedData>(_ transform: @escaping (FetchData) -> Result<MappedData, FetchError>) -> AnyFetchRequest<Query, MappedData, FetchError> {
    AnyFetchRequest(query: query) { completion -> Cancellable in
      self.run { result in
        completion(result.flatMap(transform))
      }
    }
  }

  public func map<MappedData>(_ transform: @escaping (FetchData) -> MappedData) -> AnyFetchRequest<Query, MappedData, FetchError> {
    AnyFetchRequest(query: query) { completion -> Cancellable in
      self.run { result in
        completion(result.map(transform))
      }
    }
  }

  public func map<MappedData>(_ keypath: KeyPath<FetchData, MappedData>) -> AnyFetchRequest<Query, MappedData, FetchError> {
    map { $0[keyPath: keypath] }
  }

  public func mapError<MappedError>(_ transform: @escaping (FetchError) -> MappedError) -> AnyFetchRequest<Query, FetchData, MappedError> {
    AnyFetchRequest(query: query) { completion -> Cancellable in
      self.run { result in
        completion(result.mapError(transform))
      }
    }
  }

  public func dropValue() -> AnyFetchRequest<Query, Void, FetchError> {
    map { _ in () }
  }
}
