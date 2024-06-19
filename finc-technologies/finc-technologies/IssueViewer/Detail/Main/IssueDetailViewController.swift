//
//  IssueDetailViewController.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/19.
//

import UIKit

class IssueDetailViewController: UIViewController {
    
    var issueNumber: Int!
    var issueViewModel: IssueViewModel!
    private lazy var completeViewController: CompleteViewController = {
        let storyborad = self.storyboard
        var viewController = storyborad?.instantiateViewController(withIdentifier: "CompleteViewController") as! CompleteViewController
        add(asChildViewController: viewController)
        return viewController
    }()
    private lazy var loadingViewController: LoadingViewController = {
        let storyborad = self.storyboard
        var viewController = storyborad?.instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
        add(asChildViewController: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Task {
            add(asChildViewController: loadingViewController)
            if let issue = await issueViewModel.getIssueDetail(number: issueNumber) {
                print(issue)
                remove(asChildViewController: loadingViewController)
                completeViewController.setData(issue: issue)
                add(asChildViewController: completeViewController)
            } else {
                
            }
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // 子ViewControllerを追加
        addChild(viewController)
        // Subviewとして子ViewControllerのViewを追加
        view.addSubview(viewController.view)
        // 子Viewの設定
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 子View Controllerへの通知
        viewController.didMove(toParent: self)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        // 子View Controllerへの通知
        viewController.willMove(toParent: nil)
        // 子ViewをSuperviewから削除
        viewController.view.removeFromSuperview()
        // 子View Controllerへの通知
        viewController.removeFromParent()
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
