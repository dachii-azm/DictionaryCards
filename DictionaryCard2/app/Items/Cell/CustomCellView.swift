//
//  CustomCellView.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2019/12/20.
//  Copyright © 2019 dachii. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CustomCellView: UITableViewCell {
    
    var siriButton: UIButton = {
        let siriButton = UIButton()
        siriButton.setImage(UIImage(named: PNG.siriIcon), for: .normal)
        return siriButton
    }()
    
    var talker = AVSpeechSynthesizer()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.siriButton.addTarget(self, action: #selector(self.siriButtonTapped(sender: )), for: .touchUpInside)
        itemPosition()
        self.addSubview(siriButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func siriButtonTapped(sender: Any) {
        let utterance = AVSpeechUtterance(string:(textLabel?.text!)!)
        let index = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
        let cardLanguage: [String] = [Key.Card1Language, Key.Card2Language, Key.Card3Language]
        // 言語を英語に設定
        utterance.voice = AVSpeechSynthesisVoice(language:
        (UserDefaults.standard.object(forKey: cardLanguage[index]) as! String))
        utterance.volume = 1.2
        self.talker.speak(utterance)
    }
    
}

//MARK Position
extension CustomCellView {
    private func siriButtonPosition() {
        siriButton.frame.size = CGSize(width: 40, height: 40)
        siriButton.center = CGPoint(x: self.bounds.width * 14 / 15, y: self.bounds.height/2)
    }
    
    private func itemPosition() {
        siriButtonPosition()
    }
}
