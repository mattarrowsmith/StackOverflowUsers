//
//  ViewController.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDataSource, UserListViewModelDelegate, UserListTableViewCellDelegate {
    @IBOutlet weak var userTableView: UITableView!

    private let viewModel: UserListViewModel = UserListViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var errorView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupActivityIndicator()
        setupTableView()
        Task {
            await viewModel.fetch()
        }
    }

    func setupTableView() {
        let nib = UINib(nibName: "UserListTableViewCell", bundle: nil)
        userTableView.register(nib, forCellReuseIdentifier: UserListTableViewCell.identifier)
        userTableView.allowsSelection = false
        userTableView.isHidden = true
    }

    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func update() {
        switch viewModel.loadState {
        case .loading:
            activityIndicator.isHidden = false
        case .loaded:
            userTableView.reloadData()
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            userTableView.isHidden = false
        case .error(let message):
            showErrorAlert(with: message)
        }
    }

    func update(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        userTableView.reloadRows(at: [indexPath], with: .none)
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

    private func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            Task {
                await self?.viewModel.fetch()
            }
        }
        alert.addAction(retryAction)
        present(alert, animated: true)
    }

    func didTapFollowButton(_ cell: UserListTableViewCell) {
        guard let indexPath = userTableView.indexPath(for: cell) else { return }

        Task {
            await viewModel.toggleFollow(at: indexPath.row)
        }
    }
}

