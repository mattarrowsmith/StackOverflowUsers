//
//  UserListViewModel.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//

protocol UserListViewModelDelegate {
    
}

class UserListViewModel: UserListViewModelDelegate {
    let userService: UserServiceProtocol

    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
}
