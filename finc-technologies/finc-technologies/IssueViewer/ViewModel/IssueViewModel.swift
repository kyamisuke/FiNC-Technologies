//
//  IssueViewModel.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/18.
//

import Foundation
import RxSwift

class IssueViewModel {
    var issueModel = IssueModel()
    private var gitHubAPIService = GitHubAPIService()
    var issues: Observable<[Issue]?> {
        get {
            return issueModel.Issues
        }
    }
    
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
}
