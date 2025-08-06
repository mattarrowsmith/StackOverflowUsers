//
//  ClientRepository.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 06/08/2025.
//
/// Handles local store requests for client data.
/// Client in this instance referring to the local user.

import CoreData

protocol FollowRepositoryProtocol {
    func fetchFollowedUserIds() async throws -> Set<Int>
}

class FollowRepository: FollowRepositoryProtocol {
    private let store: CoreDataStore

    init(store: CoreDataStore = CoreDataStore.shared) {
        self.store = store
    }

    enum QueryResult {
        case success(Set<Int>)
        case failure(Error)
    }

    public func fetchFollowedUserIds() async throws -> Set<Int> {
        return try await store.persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<FollowedUser> = FollowedUser.fetchRequest()
            fetchRequest.propertiesToFetch = ["id"]

            let results = try context.fetch(fetchRequest)
            let userIDs = results.compactMap { Int($0.id) }
            return Set(userIDs)
        }
    }
}
