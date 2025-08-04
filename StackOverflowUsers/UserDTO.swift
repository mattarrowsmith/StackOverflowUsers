//
//  UserModelDTO.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//

// TODO: The same as User for now, might not be necessary.
struct UserResponseDTO: Codable {
    let items: [UserDTO]
}

struct UserDTO: Codable {
    let accountId: Int
    let displayName: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
            case accountId = "account_id"
            case displayName = "display_name"
            case profileImage = "profile_image"
        }
}

struct UserMapper {
    static func map(from dto: UserResponseDTO) -> [User] {
        return dto.items.map { map(from: $0) }
    }

    static func map(from dto: UserDTO) -> User {
        return .init(
            accountId: dto.accountId,
            displayName: dto.displayName,
            profileImage: dto.profileImage
        )
    }
}
