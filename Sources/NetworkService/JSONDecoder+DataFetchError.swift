import Foundation

extension JSONDecoder {
  func decode<Object>(object: Object.Type, from data: Data) -> Result<Object, DataFetchError> where Object: Decodable {
    do {
      let value = try decode(Object.self, from: data)
      return .success(value)
    } catch let decodeError {
      let serverError = (try? decode(APIErrorModel.self, from: data)).map(DataFetchError.serverError)
      let error: DataFetchError = serverError ?? .decodingError(decodeError)
      return .failure(error)
    }
  }
}
