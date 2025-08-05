//
//  ViewController.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDataSource, UserListViewModelDelegate {
    @IBOutlet weak var userTableView: UITableView!

    var viewModel: UserListViewModel = UserListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "UserListTableViewCell", bundle: nil)
        userTableView.register(nib, forCellReuseIdentifier: UserListTableViewCell.identifier)
        viewModel.delegate = self
        Task {
            await viewModel.fetchUsers()
        }
    }

    func onLoadComplete() {
        userTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "UserListTableViewCell",
            for: indexPath
        ) as? UserListTableViewCell else {
            assertionFailure("Cannot dequeue reusable cell \(UserListTableViewCell.self) with reuseIdentifier: \(UserListTableViewCell.identifier)")
            return UITableViewCell()
        }

        cell.configure(with: viewModel.users[indexPath.row])
        return cell
    }
}

