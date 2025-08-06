//
//  UserService.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//

import Foundation
protocol UserServiceProtocol {
    func fetchUsers() async throws -> [User]
}

class UserService: UserServiceProtocol {
    let network: NetworkProtocol

    init(network: NetworkProtocol = Network()) {
        self.network = network
    }

    func fetchUsers() async throws -> [User] {
        // TODO: Use URLBuilder, make query parameters more flexible
        guard let url = URL(string: "https://api.stackexchange.com/2.2/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow") else {
            throw UserServiceError.invalidURL
        }
        let fetchUsersRequest = NetworkRequest(httpMethod: .get, url: url)

        do {
            let response = try await network.send(fetchUsersRequest)
            let responseDTO = try JSONDecoder().decode(UserResponseDTO.self, from: response.data ?? Data())
            return UserMapper.map(from: responseDTO)
        } catch {
           throw UserServiceError.invalidResponse
        }
    }

    enum UserServiceError: Error {
        case invalidURL
        case invalidResponse
    }
}
