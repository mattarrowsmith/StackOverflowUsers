import Testing
import CoreData
@testable import StackOverflowUsers

struct FollowRepositoryTests {
    var mockStore: CoreDataStore
    var sut: FollowRepository
    var managedObjectContext: NSManagedObjectContext

    init() {
        mockStore = CoreDataStore()
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
}
