//
//  DefaultSetting.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2019/12/20.
//  Copyright © 2019 dachii. All rights reserved.
//  参考: https://qiita.com/fumiyasac@github/items/c68b7ce812bf3ef48a67

import Foundation
import UIKit

class DefaultSettings: CardSetting {
    
    // MARK: - Properties
    
    private let DEFAULT_FONT_NAME      = "HiraKakuProN-W3"
    private let DEFAULT_FONT_NAME_BOLD = "HiraKakuProN-W6"
    
    private let DEFAULT_TITLE_FONT_SIZE            = 13.0
    private let DEFAULT_REMARK_FONT_SIZE           = 13.0
    private let DEFAULT_DESCRIPTION_FONT_SIZE      = 11.0
    private let DEFAULT_READ_MORE_BUTTON_FONT_SIZE = 12.0
    
    // MARK: - CardSetViewSettingプロトコルで定義した変数
    
    static var cardSetViewWidth: CGFloat = 360
    
    static var cardSetViewHeight: CGFloat = 230
    
    static var backgroundCornerRadius: CGFloat = 0.0
    
    static var backgroundBorderWidth: CGFloat = 1.2
    
    static var backgroundBorderColor: CGColor = UIColor.init(code: "#DDDDDD").cgColor
    
    static var backgroundShadowRadius: CGFloat = 3
    
    static var backgroundShadowOpacity: Float = 0.5
    
    static var backgroundShadowOffset: CGSize = CGSize(width: 0.75, height: 1.75)
    
    static var backgroundShadowColor: CGColor = UIColor.init(code: "#999999").cgColor
    
    static var backgroundColor: UIColor = UIColor.init(code: "#FFFFFF")
    
    static var beforeInitializeScale: CGFloat = 1.00
    
    static var afterInitializeScale: CGFloat = 1.00
    
    static var durationOfInitialize: TimeInterval = 0.93
    
    static var durationOfStartDragging: TimeInterval = 0.26
    
    static var durationOfReturnOriginal: TimeInterval = 0.26
    
    static var durationOfSwipeOut: TimeInterval = 0.48
    
    static var startDraggingAlpha: CGFloat = 1.0   //0.9
    
    static var stopDraggingAlpha: CGFloat = 1.0    //1
    
    static var maxScaleOfDragging: CGFloat = 1.00
    
    static var swipeXPosLimitRatio: CGFloat = 0.002   //0.52
    
    static var swipeYPosLimitRatio: CGFloat = 0.02   //0.12
}


