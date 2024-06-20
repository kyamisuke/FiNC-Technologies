//
//  CompleteViewController.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/19.
//

import UIKit

class CompleteViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var bodyLabel: UITextView!
    @IBOutlet weak var contentView: UIView!
    let formatter = MyDateFormatter.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bodyLabel.isEditable = false
    }
    
    /// Issueデータを適用する
    func setData(issue: Issue) async {
        titleLabel.text = issue.title
        do {
            try await self.fetchImage(url: issue.user.avatarURL)
        } catch(let e) {
            print(e)
        }
        userNameLabel.text = issue.user.login
        updatedAtLabel.text = formatter.string(from: issue.updatedAt)
        bodyLabel.text = issue.body
        // 高さを揃える
        adjustHeight()
    }
    
    /// Gitのアカウント画像を読み込む
    func fetchImage(url: URL) async throws {
        let url = url
        let (data, _) = try await URLSession.shared.data(from: url)
        DispatchQueue.main.async {
            guard let image = UIImage(data: data) else {
                self.userAvatarImage.image = UIImage(systemName: "person.fill.questionmark")
                return
            }
            self.userAvatarImage.image = image
        }
    }
    
    func getHeight() -> CGFloat {
        let inset16: CGFloat = 16
        let inset4: CGFloat = 4
        let inset32: CGFloat = 32
        let inset8: CGFloat = 8
        let inset24: CGFloat = 24
        
        return inset16 + titleLabel.bounds.height + inset4 +  linkButton.bounds.height + inset32 +  userAvatarImage.bounds.height + inset8 +  updatedAtLabel.bounds.height + inset24 + bodyLabel.bounds.height + inset16
    }
    
    /// コンテンツの高さを調整する
    func adjustHeight() {
        let bodyHeight = bodyLabel.sizeThatFits(CGSize(width: bodyLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
        bodyLabel.heightAnchor.constraint(equalToConstant: bodyHeight).isActive = true
//        let contentHeight: CGFloat = getHeight()
//        print(getHeight())
        contentView.heightAnchor.constraint(equalToConstant: 1100).isActive = true
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
