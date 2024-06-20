//
//  IssueModel.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/18.
//

import Foundation
import RxSwift
import RxRelay

class IssueModel {
    // 今後一覧を保存することなどを見越してBehaviourを発行
    private var issuesSubject = BehaviorSubject<[Issue]?>(value: nil)
    var IssuesObservable: Observable<[Issue]?> {
        get {
            return issuesSubject.asObservable()
        }
    }
    
    func updateIssues(issues: [Issue]) {
        issuesSubject.onNext(issues)
    }
}
