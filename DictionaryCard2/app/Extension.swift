//
//  Extension.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2019/12/20.
//  Copyright © 2019 dachii. All rights reserved.
//

import Foundation
import Foundation
import UIKit

extension UIColor {
    
    //16進数のカラーコードをiOSの設定に変換するメソッド
    //参考：【Swift】Tips: あると便利だったextension達(UIColor編)
    //https://dev.classmethod.jp/smartphone/utilty-extension-uicolor/
    convenience init(code: String, alpha: CGFloat = 1.0) {
        var color: UInt32 = 0
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        if Scanner(string: code.replacingOccurrences(of: "#", with: "")).scanHexInt32(&color) {
            r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            g = CGFloat((color & 0x00FF00) >>  8) / 255.0
            b = CGFloat( color & 0x0000FF       ) / 255.0
        }
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

extension String {
    public func isOnly(_ characterSet: CharacterSet) -> Bool {
        return self.trimmingCharacters(in: characterSet).count <= 0
    }
    
    public func isOnly(_ characterSet: CharacterSet, _ additionalString: String) -> Bool {
        var replaceCharacterSet = characterSet
        replaceCharacterSet.insert(charactersIn: additionalString)
        return isOnly(replaceCharacterSet)
    }
}

extension CGFloat {
    
    static let screenHeight = {() -> CGFloat in return UIScreen.main.bounds.size.height}
    static let screenWidth = {() -> CGFloat in return UIScreen.main.bounds.size.width}
    
    //iphone8を基準に作成
    static let HeightOfiphone8: CGFloat = 667
    
    static let scale = screenHeight()/HeightOfiphone8
}

