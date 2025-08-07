//
//  UserListViewModel.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//
import Foundation

protocol UserListViewModelDelegate: AnyObject {
    func update()
    func update(row: Int)
}

class UserListViewModel {
    let userService: UserServiceProtocol
    let followRepository: FollowRepositoryProtocol

    var users: [User] = []
    var followedUserIds: Set<Int> = []

    weak var delegate: UserListViewModelDelegate?

    var loadState: LoadState = .loading {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.update()
            }
        }
    }

    init(
        userService: UserServiceProtocol = UserService(),
        followRepository: FollowRepositoryProtocol = FollowRepository()
    ) {
        self.userService = userService
        self.followRepository = followRepository
    }

    public func fetch() async {
        loadState = .loading
        async let usersState = fetchUsers()
        async let followedState = fetchFollowedUsers()

        let results = await [usersState, followedState]

        if let errorMessage = handleErrors(in: results) {
            loadState = .error(message: errorMessage)
        } else {
            loadState = .loaded
        }
    }

    private func handleErrors(in results: [LoadState]) -> String? {
        let errorMessages = results.compactMap { result -> String? in
            if case .error(let message) = result {
                return message
            }
            return nil
        }

        return errorMessages.isEmpty ? nil : errorMessages.joined(separator: "\n")
    }

    public func fetchUsers() async -> LoadState {
        do {
            users = try await userService.fetchUsers()
        } catch {
            print("Error fetching users: \(error)")
            return .error(message: "Failed to fetch users.")
        }
        return .loaded
    }

    public func fetchFollowedUsers() async -> LoadState {
        do {
            followedUserIds = try await followRepository.fetchFollowedUserIds()
        } catch {
            print("Error fetching followed user IDs: \(error)")
            return .error(message: "Failed to fetch followed users.")
        }
        return .loaded
    }

    public func toggleFollow(at index: Int) async {
        let user = users[index]
        if followedUserIds.contains(user.accountId) {
            await unfollow(user)
        } else {
            await follow(user)
        }
        updateRow(for: user)
    }

    private func follow(_ user: User) async {
        do {
            try await followRepository.followUser(withId: user.accountId)
            followedUserIds.insert(user.accountId)
        } catch {
            print("Error following user: \(error)")
        }
    }

    private func unfollow(_ user: User) async {
        do {
            try await followRepository.unfollowUser(withId: user.accountId)
            followedUserIds.remove(user.accountId)
        } catch {
            print("Error unfollowing user: \(error)")
        }
    }

    private func updateRow(for user: User) {
        guard let index = users.firstIndex(of: user) else {
            return
        }

        DispatchQueue.main.async {
            self.delegate?.update(row: index)
        }
    }

    enum LoadState {
        case loading
        case loaded
        case error(message: String)
    }
}
