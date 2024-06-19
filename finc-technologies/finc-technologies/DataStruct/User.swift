//
//  User.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/18.
//

import Foundation

/// GitHubのユーザーの情報
struct User: Decodable {
    let login: String // ユーザー名
    let avatarURL: URL
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.login = try container.decode(String.self, forKey: .login)
        self.avatarURL = try container.decode(URL.self, forKey: .avatarURL)
    }
}
