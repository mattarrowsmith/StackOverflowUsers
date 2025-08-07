//
//  Network.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//

import Foundation

public protocol NetworkProtocol {
    func send(_ request: NetworkRequest) async throws -> NetworkResponse
}

public struct Network: NetworkProtocol {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    public func send(_ request: NetworkRequest) async throws -> NetworkResponse {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.httpMethod.description

        let (data, response) = try await session.data(for: urlRequest)
        return NetworkResponse(data: data, response: response)
    }
}

public enum HttpMethod: String {
    case get
    case post
    case put
    case delete

    public var description: String {
        rawValue.uppercased()
    }
}

public struct NetworkRequest {
    public let httpMethod: HttpMethod
    public let url: URL
}

public struct NetworkResponse {
    public let data: Data?
    public let response: URLResponse?
}




