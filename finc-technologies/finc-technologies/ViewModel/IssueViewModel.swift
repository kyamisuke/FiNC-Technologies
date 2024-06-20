//
//  IssueViewModel.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/18.
//

import Foundation
import RxSwift

class IssueViewModel {
    // Modelのインスタンスを生成
    var issueModel = IssueModel()
    // GitHubへのアクセスをリクエストするサービス
    private var gitHubAPIService = GitHubAPIService()
    // issue一覧の通知を横流しする
    var IssuesObservable: Observable<[Issue]?> {
        get {
            return issueModel.IssuesObservable
        }
    }
    
    // サービスにGitHubへのアクセスをリクエスト
    // 成功したらModelに更新を要求
    func updateIssues() async {
        do {
            let issues = try await gitHubAPIService.fetchIssues()
            DispatchQueue.main.async {
                self.issueModel.updateIssues(issues: issues)
            }
        } catch(let e) {
            print("error [updateIssues]: \(e)")
        }
    }
    
    // issueの詳細をリクエスト
    // 成功したらその内容を返す
    func getIssueDetail(number: Int) async -> Issue? {
        do {
            let issue = try await gitHubAPIService.fetchIssue(number: number)
            return issue
        } catch(let e) {
            print("error [updateIssues]: \(e)")
            return nil
        }
    }
}
