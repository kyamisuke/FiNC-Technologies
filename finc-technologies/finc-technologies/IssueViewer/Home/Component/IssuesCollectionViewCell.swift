//
//  IssuesCollectionViewCell.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/19.
//

import UIKit

class IssuesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var updatedAt: UILabel!
    @IBOutlet weak var rootView: UIStackView!
    let formatter = MyDateFormatter.shared
    var number: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //cellの枠の太さ
        self.layer.borderWidth = 1
        //cellの枠の色
        self.layer.borderColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.layer.cornerRadius = 4
        self.layer.shadowColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
        self.layer.masksToBounds = false
    }
    
    func setData(data: Issue) {
        title.text = data.title
        name.text = data.user.login
        updatedAt.text = formatter.string(from: data.updatedAt)
        number = data.number
    }
        
    func getHeight() -> CGFloat {
        return rootView.frame.height + 8*2
    }
}
