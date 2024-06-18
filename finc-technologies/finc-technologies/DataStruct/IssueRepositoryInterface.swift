//
//  IssueRepositoryInterface.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/18.
//

import Foundation

protocol IssueRepositoryInterface {
    // ページングは考えなくてよいです
    // RxSwiftなど、非同期処理を扱う外部ライブラリを利用してもかまいません
    func fetchIssues() async throws -> [Issue]
    func fetchIssue(number: Int) async throws -> Issue
}
