//
//  FollowRepositoryMock.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 08/08/2025.
//
@testable import StackOverflowUsers

struct FollowRepositoryMock: FollowRepositoryProtocol {
    let followedUserIds: Set<Int>
    let error: Error?

    init(followedUserIds: Set<Int>, error: Error? = nil) {
        self.followedUserIds = followedUserIds
        self.error = error
    }

    func fetchFollowedUserIds() async throws -> Set<Int> {
        if let error {
            throw error
        }
        return followedUserIds
    }
    
    func followUser(withId id: Int) async throws {
        if let error {
            throw error
        }
    }
    
    func unfollowUser(withId id: Int) async throws {
        if let error {
            throw error
        }
    }
}
