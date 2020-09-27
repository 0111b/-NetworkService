#if DEBUG
import Foundation
import Mock

public class MockHTTPTransport: HTTPTransport {
    public init() {}

    public func thenObtain(json: JSON) throws {
        try self.$obtainResult.thenReturns(.success((data: json.json(),
                                                     response: Stubs.httpResponse(statusCode: 200))))
    }

    public func thenObtain(data: Data) {
        self.$obtainResult.thenReturns(.success((data, Stubs.httpResponse(statusCode: 200))))
    }

    @Mock
    public var obtainResult: HTTPTransport.Result
    public lazy var obtainMock = MockFunc.mock(for: self.obtain(request:completion:))

    public func obtain(request: URLRequestConvertible,
                       completion: @escaping (HTTPTransport.Result) -> Void) -> Cancellable {
        completion(obtainResult)
        return obtainMock.callAndReturn((request, completion))
    }
}
#endif
