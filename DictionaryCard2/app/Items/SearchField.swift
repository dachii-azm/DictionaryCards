//
//  SearchField.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2019/12/20.
//  Copyright © 2019 dachii. All rights reserved.
//

import Foundation
import UIKit

class SearchField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        returnKeyType = .done
        placeholder = NSLocalizedString("PleaseEnter", comment: "")
        borderStyle = .roundedRect
        clearButtonMode = .whileEditing
    }
    
}

