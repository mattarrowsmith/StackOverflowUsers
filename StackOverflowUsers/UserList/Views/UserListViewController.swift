//
//  ViewController.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var userTableView: UITableView!

    var viewModel: UserListViewModel = UserListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "UserListTableViewCell", bundle: nil)
        userTableView.register(nib, forCellReuseIdentifier: UserListTableViewCell.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        Task {
            await viewModel.fetchUsers()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "UserListTableViewCell",
            for: indexPath
        ) as? UserListTableViewCell else {
            assertionFailure("Cannot dequeue reusable cell \(UserListTableViewCell.self) with reuseIdentifier: \(UserListTableViewCell.identifier)")
            return UITableViewCell()
        }
        let user = User(accountId: 1, displayName: "John Doe", profileImage: "https://example.com/image.png")

        cell.configure(with: user)
        return cell
    }
}

