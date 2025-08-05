//
//  UserListTableViewCell.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 05/08/2025.
//
import UIKit

class UserListTableViewCell: UITableViewCell {
    static let identifier = "UserListTableViewCell"

    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var reputationLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with user: User) {
        displayNameLabel.text = user.displayName
        reputationLabel.text = "TODO: "

        let user = User(accountId: user.accountId, displayName: user.displayName, profileImage: "https://www.gravatar.com/avatar/932fb89b9d4049cec5cba357bf0ae388?s=256&d=identicon&r=PG")

        guard let url = URL(string: user.profileImage) else { // TODO: probably best to make this a URL in the model
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                return
            }

            // Update UI on the main thread
            DispatchQueue.main.async {
                self?.profileImageView.image = image
            }
        }.resume()


    }
}

