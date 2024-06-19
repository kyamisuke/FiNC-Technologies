//
//  CompleteViewController.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/19.
//

import UIKit

class CompleteViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var bodyLabel: UITextView!
    let formatter = MyDateFormatter.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
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
    }
    
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
        userAvatarImage.image = image
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
