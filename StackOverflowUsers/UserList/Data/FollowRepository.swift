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
    func followUser(withId id: Int) async throws -> Void
    func unfollowUser(withId id: Int) async throws -> Void
}

class FollowRepository: FollowRepositoryProtocol {
    private let store: CoreDataStoreProtocol

    init(store: CoreDataStoreProtocol = CoreDataStore.shared) {
        self.store = store
    }

    enum FollowRepositoryError: Error {
        case userAlreadyFollowed
        case userNotFound
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

    public func followUser(withId id: Int) async throws -> Void {
        try await store.persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<FollowedUser> = FollowedUser.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
            fetchRequest.fetchLimit = 1

            let count = try context.count(for: fetchRequest)
            guard count == 0 else {
                throw FollowRepositoryError.userAlreadyFollowed
            }

            let followedUser = FollowedUser(context: context)
            followedUser.id = Int64(id)
            try context.save()
        }
    }

    public func unfollowUser(withId id: Int) async throws -> Void {
        try await store.persistentContainer.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<FollowedUser> = FollowedUser.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
            fetchRequest.fetchLimit = 1

            guard let user = try context.fetch(fetchRequest).first else {
                throw FollowRepositoryError.userNotFound
            }

            context.delete(user)
            try context.save()
        }
    }
}
