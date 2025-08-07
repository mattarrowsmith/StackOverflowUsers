//
//  UserListTableViewCell.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 05/08/2025.
//
import UIKit

protocol UserListTableViewCellDelegate: AnyObject {
    func didTapFollowButton(_ cell: UserListTableViewCell)
}
class UserListTableViewCell: UITableViewCell {
    static let identifier = "UserListTableViewCell"

    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var reputationLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBAction func followButtonTouched(_ sender: Any) {
        delegate?.didTapFollowButton(self)
    }

    weak var delegate: UserListTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with user: User, isFollowed: Bool) {
        displayNameLabel.text = user.displayName
        reputationLabel.text = "\(user.reputation)"
        followButton.configuration = isFollowed ? .unfollow : .follow
        guard let url = URL(string: user.profileImage) else {
            return
        }
        loadImage(from: url)
    }

    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                assertionFailure("Error downloading image: \(error)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                self?.profileImageView.image = image
            }
        }.resume()
    }
}

extension UIButton.Configuration {
    static var follow: Self {
        var config = UIButton.Configuration.filled()
        config.title = "Follow"
        config.cornerStyle = .medium
        return config
    }

    static var unfollow: Self {
        var config = UIButton.Configuration.tinted()
        config.title = "Unfollow"
        config.cornerStyle = .medium
        return config
    }
}

