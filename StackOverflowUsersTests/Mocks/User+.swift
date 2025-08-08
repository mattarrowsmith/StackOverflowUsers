//
//  User+.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 08/08/2025.
//
@testable import StackOverflowUsers

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
