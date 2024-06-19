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
}
