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
    
    // 画面の状態を管理する変数
    private var state = PublishSubject<ConnectState>()
    private var preState: ConnectState?
    
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
            .subscribe(onNext: {
                self.reconnect()
            })
            .disposed(by: disposeBag)
        // 画面の状態を管理
        // 初期値はLoading
        state
            .subscribe(onNext: updateState)
            .disposed(by: disposeBag)
        state.onNext(.Loading)
    }
    
    // 再接続処理
    private func reconnect() {
        state.onNext(.Loading)
    }
    
    // 通信処理
    private func connect() {
        Task {
            // issueの詳細の取得を試みる
            if let issue = await issueViewModel.getIssueDetail(number: issueNumber) {
                // 成功したらVCに情報を伝える
                await completeViewController.setData(issue: issue)
                // 状態の更新
                DispatchQueue.main.async {
                    self.state.onNext(.Complete)
                }
            } else {
                // 状態の更新
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
    
    // 画面の状態を管理する
    private func updateState(state: ConnectState) {
        switch state {
        case .Loading:
            if preState != nil && preState == .Failed {
                remove(asChildViewController: failedViewController)
            }
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
        preState = state
    }
    
    // 子ビューを追加する
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
    
    // 子ビューを削除する
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
