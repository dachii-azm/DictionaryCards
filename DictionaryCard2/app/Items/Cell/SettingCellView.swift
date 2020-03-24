//
//  CustomCardCellView.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2020/03/11.
//  Copyright © 2020 dachii. All rights reserved.
//

import Foundation
import UIKit

class SettingCellView: UITableViewCell {
    
    var languageLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .gray
       return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(languageLabel)
        self.languageLabelPosition()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func languageLabelPosition() {
        self.languageLabel.frame = CGRect(x:0, y: 0, width: self.bounds.width/5, height: self.bounds.height)
        self.languageLabel.center = CGPoint(x: self.bounds.width * 9 / 10, y:self.bounds.height / 2)
    }
}

