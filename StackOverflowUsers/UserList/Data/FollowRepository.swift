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
    func fetchFollowedUserIds(completion: @escaping (FollowRepository.QueryResult) -> Void)
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

    public func fetchFollowedUserIds(completion: @escaping(QueryResult) -> Void) -> Void {
        store.run { context in
            let fetchRequest: NSFetchRequest<FollowedUser> = FollowedUser.fetchRequest()
            fetchRequest.propertiesToFetch = ["id"]

            do {
                let results = try context.fetch(fetchRequest)
                let userIDs = results.compactMap { Int($0.id) }
                let result = QueryResult.success(Set(userIDs))
                completion(result)
            } catch {
                completion(.failure(error))
            }
        }
    }
}
