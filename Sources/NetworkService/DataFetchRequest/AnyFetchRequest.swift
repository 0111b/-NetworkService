public final class AnyFetchRequest<SourceData, SourceError: Error>: DataFetchRequest {
  public typealias FetchData = SourceData
  public typealias FetchError = SourceError
  typealias Run = (@escaping FetchCompletion) -> Cancellable

  @discardableResult
  public func run(completion: @escaping FetchCompletion) -> Cancellable {
    return _run(completion)
  }
  
  public func eraseToAny() -> AnyFetchRequest<FetchData, FetchError> {
    return self
  }
  
  init(run: @escaping Run) {
    self._run = run
  }
  
  init<SourceRequest>(_ source: SourceRequest)
  where SourceRequest: DataFetchRequest,
        SourceRequest.FetchData == FetchData,
        SourceRequest.FetchError == FetchError {
    self._run = source.run
  }
  
  private let _run: Run
}

public extension DataFetchRequest {
  func eraseToAny() -> AnyFetchRequest<FetchData, FetchError> {
    return AnyFetchRequest(self)
  }
}
