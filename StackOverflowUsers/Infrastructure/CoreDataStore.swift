//
//  CoreDataStore.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 06/08/2025.
//

import CoreData

protocol CoreDataStoreProtocol {
    var persistentContainer: NSPersistentContainer { get }
    func saveContext()
}

class CoreDataStore: CoreDataStoreProtocol {
    static let shared = CoreDataStore()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
