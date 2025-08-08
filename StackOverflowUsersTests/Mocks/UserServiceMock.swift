//
//  UserServiceMock.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 08/08/2025.
//
@testable import StackOverflowUsers

struct UserServiceMock: UserServiceProtocol {
    let users: [User]
    let error: Error?

    init(users: [User] = [], error: Error? = nil) {
        self.users = users
        self.error = error
    }

    func fetchUsers() async throws -> [User] {
        if let error {
            throw error
        } else {
            return users
        }
    }
}
