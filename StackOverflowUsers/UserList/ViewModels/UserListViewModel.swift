//
//  UserListViewModel.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//
import Foundation

protocol UserListViewModelDelegate: AnyObject {
    func onLoadComplete()
}

class UserListViewModel {
    let userService: UserServiceProtocol
    let followRepository: FollowRepositoryProtocol

    var users: [User] = []
    var followedUserIds: Set<Int> = []

    weak var delegate: UserListViewModelDelegate?

    init(
        userService: UserServiceProtocol = UserService(),
        followRepository: FollowRepositoryProtocol = FollowRepository()
    ) {
        self.userService = userService
        self.followRepository = followRepository
    }

    public func fetch() async {
        await fetchUsers()
        await fetchFollowedUsers()
        loadComplete()
    }

    public func fetchUsers() async {
        do {
            users = try await userService.fetchUsers()
        } catch {
            print("Error fetching users: \(error)")
        }
    }

    public func fetchFollowedUsers() async {
        do {
            followedUserIds = try await followRepository.fetchFollowedUserIds()
        } catch {
            print("Error fetching followed user IDs: \(error)")
        }
    }

    public func followUser(user: User) async {
        do {
            await followRepository.followUser(withId: user.accountId)
        } catch {
            print("Error following user: \(error)")
        }
    }

    public func unfollowUser(user: User) async {
        do {
            try await followRepository.unfollowUser(withId: user.accountId)
        } catch {
            print("Error unfollowing user: \(error)")
        }
    }

    private func loadComplete() {
        DispatchQueue.main.async {
            self.delegate?.onLoadComplete()
        }
    }
}
