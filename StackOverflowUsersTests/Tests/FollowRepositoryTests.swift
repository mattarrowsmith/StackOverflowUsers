import Testing
import CoreData
@testable import StackOverflowUsers

@Suite(.serialized)
struct FollowRepositoryTests {
    var mockStore: CoreDataStoreMock
    var sut: FollowRepository
    var managedObjectContext: NSManagedObjectContext

    init() {
        mockStore = CoreDataStoreMock()
        managedObjectContext = mockStore.persistentContainer.viewContext
        sut = FollowRepository(store: mockStore)
    }

    private func createAndSaveFollowedUser(id: Int) throws {
        let user = FollowedUser(context: managedObjectContext)
        user.id = Int64(id)
        try managedObjectContext.save()
    }

    @Test
    func fetchFollowedUserIds_whenStoreIsEmpty_returnsEmptySet() async throws {
        let ids = try await sut.fetchFollowedUserIds()
        #expect(ids.isEmpty)
    }

    @Test
    func fetchFollowedUserIds_whenStoreHasUsers_returnsCorrectIds() async throws {
        try createAndSaveFollowedUser(id: 1)
        try createAndSaveFollowedUser(id: 2)

        let expectedIds: Set<Int> = [1, 2]
        let ids = try await sut.fetchFollowedUserIds()

        #expect(ids == expectedIds)
    }

    @Test
    func followUser_whenUserIsNotFollowed_succeeds() async throws {
        let userId = 1
        try await sut.followUser(withId: userId)

        let ids = try await sut.fetchFollowedUserIds()
        #expect(ids.contains(userId))
        #expect(ids.count == 1)
    }

    @Test
    func followUser_whenUserIsAlreadyFollowed_throwsError() async throws {
        let userId = 456
        try createAndSaveFollowedUser(id: userId)

        await #expect(throws: FollowRepository.FollowRepositoryError.userAlreadyFollowed) {
            try await sut.followUser(withId: userId)
        }
    }

    @Test
    func unfollowUser_whenUserExists_succeeds() async throws {
        let userId = 1
        try createAndSaveFollowedUser(id: userId)

        var ids = try await sut.fetchFollowedUserIds()
        #expect(ids.contains(userId))

        try await sut.unfollowUser(withId: userId)

        ids = try await sut.fetchFollowedUserIds()
        #expect(!ids.contains(userId))
        #expect(ids.isEmpty)
    }

    @Test
    func unfollowUser_whenUserDoesNotExist_throwsError() async throws {
        await #expect(throws: FollowRepository.FollowRepositoryError.userNotFound) {
            try await sut.unfollowUser(withId: 1)
        }
    }
}
