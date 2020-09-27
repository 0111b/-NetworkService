import Foundation

public struct APIErrorModel: Error, Decodable, LocalizedError {
  public let message: String

  public var errorDescription: String? { return message }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    if let value = try? container.decode(String.self, forKey: .error) {
      message = value
    } else {
      message = try container.decode(ErrorContainer.self, forKey: .error).message
    }
  }

  public init(message: String) {
    self.message = message
  }

  private enum CodingKeys: String, CodingKey {
    case error
    case message
  }

  private struct ErrorContainer: Decodable {
    let message: String
  }
}
