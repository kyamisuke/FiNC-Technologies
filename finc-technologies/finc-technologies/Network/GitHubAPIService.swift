//
//  GitHubAPIService.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/18.
//

import UIKit

class GitHubAPIService: IssueRepositoryInterface {
    private let baseURL = "https://api.github.com/repos/kyamisuke/finc-technologies/issues"
    private let decoder = JSONDecoder()
    
    init() {
        decoder.dateDecodingStrategy = .iso8601  // 追加
    }
    
    func fetchIssues() async throws -> [Issue] {
//        let stubData = NSDataAsset(name: "StubData")!
        let url = URL(string: baseURL)!
        let (data, _) = try await URLSession.shared.data(from: url)
//        let issue = try JSONDecoder().decode([Issue].self, from: stubData.data)
        var issue = try JSONDecoder().decode([Issue].self, from: data)
        issue.sort { $0.number < $1.number }
        return issue
    }
    
    func fetchIssue(number: Int) async throws -> Issue {
        let url = URL(string: "\(baseURL)/\(number)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let issue = try JSONDecoder().decode(Issue.self, from: data)
        return issue
    }
    
}
