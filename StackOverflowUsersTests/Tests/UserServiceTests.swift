//
//  UserServiceTests.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 07/08/2025.
//

import Testing
import Foundation
@testable import StackOverflowUsers

struct UserServiceTests {

    enum MockError: Error { case networkUnavailable }

    @Test
    func fetchUsers_whenNetworkSucceeds_returnsUsers() async throws {
        let mockUsers: [UserDTO] = [.mock, .mock]
        let wrapper = UserResponseDTO(items: mockUsers)
        let responseData = try JSONEncoder().encode(wrapper)
        let mockResponse = NetworkResponse(data: responseData, response: URLResponse())
        let mockNetwork = MockNetwork(response: mockResponse)
        let sut = UserService(network: mockNetwork)

        let fetchedUsers = try await sut.fetchUsers()

        #expect(fetchedUsers == [User.mock, User.mock])
    }
}

extension UserDTO {
    public static var mock: Self {
        .init(
            accountId: 1,
            displayName: "Mock User",
            profileImage: "https://example.com/image.png",
            reputation: 1000
        )
    }
}

extension User {
    public static var mock: Self {
        .init(
            accountId: 1,
            displayName: "Mock User",
            profileImage: "https://example.com/image.png",
            reputation: 1000
        )
    }
}
