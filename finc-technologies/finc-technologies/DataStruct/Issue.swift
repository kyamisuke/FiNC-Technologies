//
//  Issue.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/18.
//

import Foundation

/// GitHubのissueの情報
struct Issue {
    let number: Int
    let title: String // 一覧画面・詳細画面に表示
    let body: String // 詳細画面に表示
    let url: URL // 詳細画面に表示し、それをタップしたらSafariViewControllerで開く
    let user: User // 一覧画面にアバター画像と名前を表示
    let updatedAt: Date // 一覧画面・詳細画面に表示
}
