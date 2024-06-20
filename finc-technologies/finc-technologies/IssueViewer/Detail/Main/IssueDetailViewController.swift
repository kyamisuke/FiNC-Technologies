//
//  IssueDetailViewController.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/19.
//

import UIKit
import RxSwift

class IssueDetailViewController: UIViewController {
    private enum ConnectState {
        case Loading
        case Complete
        case Failed
    }
    
    var issueNumber: Int!
    var issueViewModel: IssueViewModel!
    private var state = BehaviorSubject<ConnectState>(value: .Loading)
    var currentVC: ViewController?
    let disposeBag = DisposeBag()
    
    // 通信成功時の画面
    private lazy var completeViewController: CompleteViewController = {
        let storyborad = self.storyboard
        var viewController = storyborad?.instantiateViewController(withIdentifier: "CompleteViewController") as! CompleteViewController
        add(asChildViewController: viewController)
        return viewController
    }()
    // 通信中の画面
    private lazy var loadingViewController: LoadingViewController = {
        let storyborad = self.storyboard
        var viewController = storyborad?.instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
        add(asChildViewController: viewController)
        return viewController
    }()
    // 通信中の画面
    private lazy var failedViewController: FailedViewController = {
        let storyborad = self.storyboard
        var viewController = storyborad?.instantiateViewController(withIdentifier: "FailedViewController") as! FailedViewController
        add(asChildViewController: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // failed画面からの通知を購読
        failedViewController.reconnectSubject
            .skip(1)
            .subscribe(onNext: {
                print("reconnect")
                self.reconnect()
            })
            .disposed(by: disposeBag)
        state
            .subscribe(onNext: updateState)
            .disposed(by: disposeBag)
    }
    
    private func reconnect() {
        remove(asChildViewController: self.failedViewController)
        state.onNext(.Loading)
    }
    
    private func connect() {
        Task {
            if let issue = await issueViewModel.getIssueDetail(number: issueNumber) {
                await completeViewController.setData(issue: issue)
                DispatchQueue.main.async {
                    self.state.onNext(.Complete)
                }
            } else {
                DispatchQueue.main.async {
                    self.state.onNext(.Failed)
                }
            }
            // 絶対に失敗させたい時のコード
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.remove(asChildViewController: self.loadingViewController)
//                self.add(asChildViewController: self.failedViewController)
//            }
        }
    }
    
    private func updateState(state: ConnectState) {
        switch state {
        case .Loading:
            add(asChildViewController: loadingViewController)
            connect()
        case .Complete:
            remove(asChildViewController: loadingViewController)
            add(asChildViewController: completeViewController)
        case .Failed:
            remove(asChildViewController: loadingViewController)
            add(asChildViewController: failedViewController)
            failedViewController.appearAlert()
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
