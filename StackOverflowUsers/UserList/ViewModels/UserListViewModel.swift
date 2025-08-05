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
    var users: [User] = []
    weak var delegate: UserListViewModelDelegate?

    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }

    public func fetchUsers() async {
        users = await userService.fetchUsers()
        loadComplete()
    }

    private func loadComplete() {
        DispatchQueue.main.async {
            self.delegate?.onLoadComplete()
        }
    }
}
