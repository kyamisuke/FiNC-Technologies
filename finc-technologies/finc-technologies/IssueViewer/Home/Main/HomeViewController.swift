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
    var issues: [Issue]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "IssuesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IssuesCollectionViewCell")
        
        Task {
            await issueViewModel.updateIssues()
        }
        
        issueViewModel.issues.subscribe(onNext: updateCollectionView)
            .disposed(by: disposeBag)
        
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        }
    }
    
    func updateCollectionView(value: [Issue]?) {
        issues = value
        collectionView.reloadData()
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return issues?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssuesCollectionViewCell", for: indexPath) as! IssuesCollectionViewCell
        if let issue = issues?[indexPath.row] {
            cell.setData(data: issue)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let cell = collectionView.cellForItem(at: indexPath) as! IssuesCollectionViewCell
            let storyboard = UIStoryboard(name: "IssueDetailView", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "IssueDetailViewController") as? IssueDetailViewController {
                // viewControllerの設定や表示処理を行う
                vc.issueNumber = cell.number
                vc.issueViewModel = self.issueViewModel
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                print("ViewController with identifier 'IssueDetailViewController' could not be instantiated.")
            }
        }
    }
}

// セルのサイズを調整する
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    // セルサイズを指定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 横方向のサイズを調整
        let cellSizeWidth: CGFloat = collectionView.frame.width / 1.05
        let cellSizeHeight: CGFloat = 100
        // widthとheightのサイズを返す
        return CGSize(width: cellSizeWidth, height: cellSizeHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0 // 行間
    }

}
