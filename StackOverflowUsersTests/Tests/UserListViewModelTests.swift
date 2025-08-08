//
//  UserListViewModelTests.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 08/08/2025.
//
import Testing

@testable import StackOverflowUsers

struct UserListViewModelTests {
    @Test
    func fetch_whenServicesSucceed_populatesDataAndSetsLoadedState() async {
        let mockUsers: [User] = [.mock]
        let mockFollowedIds: Set<Int> = [1]
        let userService = UserServiceMock(users: mockUsers)
        let followRepository = FollowRepositoryMock(followedUserIds: mockFollowedIds)
        let sut = UserListViewModel(userService: userService, followRepository: followRepository)

        await sut.fetch()

        #expect(sut.users == mockUsers)
        #expect(sut.followedUserIds == mockFollowedIds)
        #expect(sut.loadState == .loaded)
    }

    @Test
    func fetch_whenUserServiceFails_setsErrorState() async {
        let userService = UserServiceMock(error: MockError.any)
        let followRepository = FollowRepositoryMock(followedUserIds: [])
        let sut = UserListViewModel(userService: userService, followRepository: followRepository)

        await sut.fetch()

        #expect(sut.loadState == .error(message: "Failed to fetch users."))
    }

    @Test
    func fetch_whenFollowRepositoryFails_setsErrorState() async {
        let mockUsers: [User] = [.mock]
        let userService = UserServiceMock(users: mockUsers)
        let followRepository = FollowRepositoryMock(followedUserIds: [], error: MockError.any)
        let sut = UserListViewModel(userService: userService, followRepository: followRepository)

        await sut.fetch()

        #expect(sut.loadState == .error(message: "Failed to fetch followed users."))
    }

    @Test
    func fetch_whenMultipleFails_setsErrorStateWithMultipleMessages() async {
        let userService = UserServiceMock(error: MockError.any)
        let followRepository = FollowRepositoryMock(followedUserIds: [], error: MockError.any)
        let sut = UserListViewModel(userService: userService, followRepository: followRepository)

        await sut.fetch()

        #expect(sut.loadState == .error(message: "Failed to fetch users.\nFailed to fetch followed users."))
    }

    @Test
    func toggleFollow_whenUserIsNotFollowed_followsUser() async {
        let mockUsers: [User] = [.mock]
        let userService = UserServiceMock(users: mockUsers)
        let followRepository = FollowRepositoryMock(followedUserIds: [])
        let sut = UserListViewModel(userService: userService, followRepository: followRepository)
        await sut.fetch()

        await sut.toggleFollow(at: 0)

        #expect(sut.followedUserIds.contains(mockUsers[0].accountId))
    }

    @Test
    func toggleFollow_whenUserIsFollowed_unfollowsUser() async {
        let mockUsers: [User] = [.mock]
        let userService = UserServiceMock(users: mockUsers)
        let followRepository = FollowRepositoryMock(followedUserIds: [1])
        let sut = UserListViewModel(userService: userService, followRepository: followRepository)
        await sut.fetch()

        await sut.toggleFollow(at: 0)

        #expect(!sut.followedUserIds.contains(mockUsers[0].accountId))
    }

    @Test
    func toggleFollow_whenFollowActionFails_doesNotChangeState() async {
        let mockUsers: [User] = [.mock]
        let userService = UserServiceMock(users: mockUsers)
        let followRepository = FollowRepositoryMock(followedUserIds: [], error: MockError.any)
        let sut = UserListViewModel(userService: userService, followRepository: followRepository)
        _ = await sut.fetchUsers()

        await sut.toggleFollow(at: 0)

        #expect(sut.followedUserIds.isEmpty)
    }

    enum MockError: Error {
        case any
    }
}
