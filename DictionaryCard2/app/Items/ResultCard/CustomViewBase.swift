//
//  CustomViewBase.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2019/12/20.
//  Copyright © 2019 dachii. All rights reserved.
//  参考: https://qiita.com/fumiyasac@github/items/c68b7ce812bf3ef48a67

import Foundation
import UIKit

//自作のXibを使用するための基底となるUIViewを継承したクラス
class CustomViewBase: UIView {
    
    //コンテンツ表示用のView
    weak var contentView: UIView!
    
    //このカスタムビューをコードで使用する際の初期化処理
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initContentView()
    }
    
    //このカスタムビューをInterfaceBuilderで使用する際の初期化処理
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initContentView()
    }
    
    //コンテンツ表示用Viewの初期化処理
    private func initContentView() {
        
        //追加するcontentViewのクラス名を取得する
        let viewClass: AnyClass = type(of: self)
        
        //追加するcontentViewに関する設定をする
        contentView = Bundle(for: viewClass)
            .loadNibNamed(String(describing: viewClass), owner: self, options: nil)?.first as? UIView
        contentView.autoresizingMask = autoresizingMask
        contentView.frame = bounds
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        //追加するcontentViewの制約を設定する ※上下左右へ0の制約を追加する
        let bindings = ["view": contentView as Any]
        
        let contentViewConstraintH = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[view]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: bindings
        )
        let contentViewConstraintV = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[view]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: bindings
        )
        addConstraints(contentViewConstraintH)
        addConstraints(contentViewConstraintV)
        
        initWith()
    }
    
    // MARK: - Function
    
    // このメソッドは継承先のカスタムビューのInitialize時に使用する
    func initWith() {}
}


