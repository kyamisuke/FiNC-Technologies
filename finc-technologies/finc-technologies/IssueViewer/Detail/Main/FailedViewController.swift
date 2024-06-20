//
//  FailedViewController.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/20.
//

import UIKit
import RxSwift

class FailedViewController: UIViewController {
    var reconnectSubject = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func tapReconnectButton(_ sender: Any) {
        reconnectSubject.onNext(())
    }
    
    func appearAlert() {
        let alert: UIAlertController = UIAlertController(title: "通信失敗", message: "Issueの取得に失敗しました。再接続してください。", preferredStyle: .alert)
        
        //OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)

        // Do any additional setup after loading the view.
        //UIAlertControllerにActionを追加
        alert.addAction(defaultAction)
        
        //Alertを表示
        present(alert, animated: true, completion: nil)
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
