//
//  HomeViewController.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/18.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    var issueViewModel = IssueViewModel()
    let disposeBag = DisposeBag()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home")
        // Do any additional setup after loading the view.
        Task {
            await issueViewModel.updateIssues()
        }
        
        issueViewModel.issues.subscribe(onNext: { [weak self] value in
            print("value = \(value)")
        })
        .disposed(by: disposeBag)
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
