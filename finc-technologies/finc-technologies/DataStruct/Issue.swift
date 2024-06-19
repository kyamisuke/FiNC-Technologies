//
//  Issue.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/18.
//

import Foundation

/// GitHubのissueの情報
struct Issue: Decodable {
    let number: Int
    let title: String // 一覧画面・詳細画面に表示
    let body: String // 詳細画面に表示
    let url: URL // 詳細画面に表示し、それをタップしたらSafariViewControllerで開く
    let user: User // 一覧画面にアバター画像と名前を表示
    let updatedAt: Date // 一覧画面・詳細画面に表示
    
    enum CodingKeys: CodingKey {
        case number
        case title
        case body
        case url
        case user
        case updatedAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.number = try container.decode(Int.self, forKey: .number)
        self.title = try container.decode(String.self, forKey: .title)
        self.body = try container.decode(String.self, forKey: .body)
        self.url = try container.decode(URL.self, forKey: .url)
        self.user = try container.decode(User.self, forKey: .user)
        let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
        
        // Use DateFormatter to parse the date string
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: updatedAtString) else {
            throw DecodingError.dataCorruptedError(forKey: .updatedAt, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
        
        self.updatedAt = date
    }
}
