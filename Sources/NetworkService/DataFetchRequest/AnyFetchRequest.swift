public final class AnyFetchRequest<SourceQuery, SourceData, SourceError: Error>: DataFetchRequest {
  public typealias Query = SourceQuery
  public typealias FetchData = SourceData
  public typealias FetchError = SourceError
  typealias Run = (@escaping FetchCompletion) -> Cancellable
  
  public let query: Query
  
  @discardableResult
  public func run(completion: @escaping FetchCompletion) -> Cancellable {
    return _run(completion)
  }
  
  public func eraseToAny() -> AnyFetchRequest<Query, FetchData, FetchError> {
    return self
  }
  
  init(query: Query, run: @escaping Run) {
    self.query = query
    self._run = run
  }
  
  init<SourceRequest>(_ source: SourceRequest)
  where SourceRequest: DataFetchRequest,
        SourceRequest.FetchData == FetchData,
        SourceRequest.FetchError == FetchError,
        SourceRequest.Query == Query {
    self.query = source.query
    self._run = source.run
  }
  
  private let _run: Run
}

public extension DataFetchRequest {
  func eraseToAny() -> AnyFetchRequest<Query, FetchData, FetchError> {
    return AnyFetchRequest(self)
  }
}
