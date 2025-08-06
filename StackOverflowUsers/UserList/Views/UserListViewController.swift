//
//  ViewController.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDataSource, UserListViewModelDelegate, UserListTableViewCellDelegate {
    @IBOutlet weak var userTableView: UITableView!

    var viewModel: UserListViewModel = UserListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "UserListTableViewCell", bundle: nil)
        userTableView.register(nib, forCellReuseIdentifier: UserListTableViewCell.identifier)
        viewModel.delegate = self
        Task {
            await viewModel.fetch()
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

        let user = viewModel.users[indexPath.row]
        cell.configure(with: user, isFollowed: viewModel.followedUserIds.contains(user.accountId))
        cell.delegate = self
        return cell
    }

    func didTapFollowButton(_ cell: UserListTableViewCell) {
        guard let indexPath = userTableView.indexPath(for: cell) else { return }

        let user = viewModel.users[indexPath.row]
        Task {
            await viewModel.follow(user)
        }
    }
}

