//
//  ViewController.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UserListTableViewCell()
    }
    
    var viewModel: UserListViewModel = UserListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    override func viewWillAppear(_ animated: Bool) {
        Task {
            await viewModel.fetchUsers()
        }
    }


}

