//
//  NetworkMock.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 07/08/2025.
//
import Foundation

@testable import StackOverflowUsers

class MockNetwork: NetworkProtocol {
    let response: NetworkResponse
    var error: Error?

    init(response: NetworkResponse) {
        self.response = response
    }

    func send(_ request: NetworkRequest) async throws -> NetworkResponse {
        if let error = error {
            throw error
        } else {
            return response
        }
    }
}
