//
//  UserListViewModel.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//

protocol UserListViewModelDelegate {
    func fetchUsers() async
}

class UserListViewModel: UserListViewModelDelegate {
    let userService: UserServiceProtocol

    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }

    public func fetchUsers() async {
        await userService.fetchUsers()
    }
}
