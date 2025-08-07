//
//  User.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//

struct User: Codable, Equatable {
    let accountId: Int
    let displayName: String
    let profileImage: String
    let reputation: Int
}
