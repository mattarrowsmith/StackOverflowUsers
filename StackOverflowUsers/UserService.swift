//
//  UserService.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//

import Foundation
protocol UserServiceProtocol {
    func fetchUsers() async -> [User]
}

class UserService: UserServiceProtocol {
    let network: NetworkProtocol

    init(network: NetworkProtocol = Network()) {
        self.network = network
    }

    func fetchUsers() async -> [User] {
        // TODO: Use URLBuilder
        guard let url = URL(string: "http://api.stackexchange.com/2.2/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow") else {
            return [] // throw error instead?
        }
        let fetchUsersRequest = NetworkRequest(httpMethod: .get, url: url)

        do {
            let response = try await network.send(fetchUsersRequest)
            let users = try JSONDecoder().decode([User].self, from: response.data ?? Data())
            return users
        } catch {
            print("Error fetching users: \(error)")
        }

        return []
    }
}
