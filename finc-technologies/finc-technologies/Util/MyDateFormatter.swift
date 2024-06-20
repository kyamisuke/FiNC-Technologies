//
//  MyDateFormatter.swift
//  finc-technologies
//
//  Created by 村上航輔 on 2024/06/19.
//

import Foundation

final class MyDateFormatter: DateFormatter {
    static let shared = MyDateFormatter()
    
    private override init() {
        super.init()
        self.dateFormat = "yyyy年M月d日 H:mm"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
