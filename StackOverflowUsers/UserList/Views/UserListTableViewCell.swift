//
//  UserListTableViewCell.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 05/08/2025.
//
import UIKit

class UserListTableViewCell: UITableViewCell {
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var reputationLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

