public enum DataFetchError: Error {
  case badRequest
  case invalidStatusCode
  case decodingError(Error)
  case transportError(Error)
  case serverError(APIErrorModel)
}
