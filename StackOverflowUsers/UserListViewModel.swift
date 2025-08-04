//
//  UserListViewModel.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//

protocol UserListViewModelDelegate {
    
}

class UserListViewModel: UserListViewModelDelegate {
    let UserRepository: UserServiceProtocol

    init(userRepository: UserServiceProtocol) {
        self.UserRepository = userRepository
    }
}
