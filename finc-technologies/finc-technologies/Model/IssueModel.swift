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
    private var issues = PublishSubject<[Issue]?>()
    var Issues: Observable<[Issue]?> {
        get {
            return issues.asObservable()
        }
    }
    
    func updateIssues(issues: [Issue]) {
        self.issues.onNext(issues)
    }
}
