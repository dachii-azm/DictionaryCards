//
//  ResultCardView.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2019/12/20.
//  参考: https://qiita.com/fumiyasac@github/items/c68b7ce812bf3ef48a67
//

import Foundation
import UIKit
import AVFoundation

protocol CardDelegate: NSObjectProtocol {
    
    // ドラッグ開始時に実行されるアクション
    func beganDragging(_ cardView: ResultCardView)
    
    // 位置の変化が生じた際に実行されるアクション
    func updatePosition(_ cardView: ResultCardView, centerX: CGFloat, centerY: CGFloat)
    
    // 右側へのスワイプ動作が完了した場合に実行されるアクション
    func swipedRightPosition(_ cardView: ResultCardView)
    
    //　左側へ
    func swipedLeftPosition(_ cardView: ResultCardView)
    
    // 元の位置に戻る動作が完了したに実行されるアクション
    func returnToOriginalPosition(_ cardView: ResultCardView)
}


class ResultCardView: CustomViewBase {
   
    //表と裏のラベルを宣言
    var Jplabel: UILabel!
    var Enlabel: UILabel!
    var talker = AVSpeechSynthesizer()
    
    //中心を決める変数
    private var initialCenter: CGPoint = CGPoint(
        x: UIScreen.main.bounds.size.width / 2,
        y: UIScreen.main.bounds.size.height / 2
    )
    //傾きの変数
    private var initialTransform: CGAffineTransform = .identity
    //
    private var originalPoint: CGPoint = CGPoint.zero
    //カードに関する設定
    private var xPositionFromCenter: CGFloat = 0.0
    private var yPositionFromCenter: CGFloat = 0.0
    private var currentMoveXPercentFromCenter: CGFloat = 0.0
    private var currentMoveYPercentFromCenter: CGFloat = 0.0
    
    private let durationOfInitialize: TimeInterval    = DefaultSettings.durationOfInitialize
    private let durationOfStartDragging: TimeInterval = DefaultSettings.durationOfStartDragging
    
    private let durationOfReturnOriginal: TimeInterval = DefaultSettings.durationOfReturnOriginal
    private let durationOfSwipeOut: TimeInterval       = DefaultSettings.durationOfSwipeOut
    
    private let startDraggingAlpha: CGFloat = DefaultSettings.startDraggingAlpha
    private let stopDraggingAlpha: CGFloat  = DefaultSettings.stopDraggingAlpha
    private let maxScaleOfDragging: CGFloat = DefaultSettings.maxScaleOfDragging
    
    private let swipeXPosLimitRatio: CGFloat = DefaultSettings.swipeXPosLimitRatio
    private let swipeYPosLimitRatio: CGFloat = DefaultSettings.swipeYPosLimitRatio
    
    private let beforeInitializeScale: CGFloat = DefaultSettings.beforeInitializeScale
    private let afterInitializeScale: CGFloat  = DefaultSettings.afterInitializeScale
    
    weak var delegate: CardDelegate?
    //各viewを識別するインデックス
    var index: Int = 0
    
    override func initWith() {
        setupCardSetView()
        setupPanGestureRecognizer()
        setupSlopeAndIntercept()
        
        // ラベルの作成
        self.Jplabel = UILabel()
        Jplabel.frame = CGRect(x:0, y: 0, width: self.bounds.width, height: self.bounds.height)
        Jplabel.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        Jplabel.text = ""
        Jplabel.textColor = .black
        Jplabel.font = UIFont.systemFont(ofSize: 50)
        Jplabel.textAlignment = NSTextAlignment.center
        self.addSubview(Jplabel)
    }

     @objc func siriButtonTapped(sender: Any) {
        configureCardLanguage()
        let index = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
        let cardLanguage: [String] = [Key.Card1Language, Key.Card2Language, Key.Card3Language]
        let utterance = AVSpeechUtterance(string:self.Jplabel.text!)
        // 言語を英語に設定
        utterance.voice = AVSpeechSynthesisVoice(language:
        (UserDefaults.standard.object(forKey: cardLanguage[index]) as! String))
        utterance.volume = 1.2
        self.talker.speak(utterance)
    }
    
    //UserDefaults
    private func configureCardLanguage() {
        if UserDefaults.standard.object(forKey: Key.Card1Language) == nil {
            UserDefaults.standard.set("en-En", forKey: Key.Card1Language)
        }
        
        if UserDefaults.standard.object(forKey: Key.Card2Language) == nil {
            UserDefaults.standard.set("en-En", forKey: Key.Card2Language)
        }
        
        if UserDefaults.standard.object(forKey: Key.Card3Language) == nil {
            UserDefaults.standard.set("en-En", forKey: Key.Card3Language)
        }
    }
        
    @objc private func startDragging(_ sender: UIPanGestureRecognizer) {
        
        // 中心位置からのX軸＆Y軸方向の位置の値を更新する
        xPositionFromCenter = sender.translation(in: self).x
        yPositionFromCenter = sender.translation(in: self).y
        
        // UIPangestureRecognizerの状態に応じた処理を行う
        switch sender.state {
            
        // ドラッグ開始時の処理
        case .began:
            
            // ドラッグ処理開始時のViewがある位置を取得する
            originalPoint = CGPoint(
                x: self.center.x - xPositionFromCenter,
                y: self.center.y - yPositionFromCenter
            )
            
            // DelegeteメソッドのbeganDraggingを実行する
            self.delegate?.beganDragging(self)
            
            // ドラッグ処理開始時のViewのアルファ値を変更する
            UIView.animate(withDuration: durationOfStartDragging, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.alpha = self.startDraggingAlpha
            }, completion: nil)
            
            break
            
        // ドラッグ最中の処理
        case .changed:
            
            // 動かした位置の中心位置を取得する
            let newCenterX = originalPoint.x + xPositionFromCenter
            let newCenterY = originalPoint.y + yPositionFromCenter
            
            // Viewの中心位置を更新して動きをつける
            self.center = CGPoint(x: newCenterX, y: newCenterY)
            
            // DelegeteメソッドのupdatePositionを実行する
            self.delegate?.updatePosition(self, centerX: newCenterX, centerY: newCenterY)
            
            // 中心位置からのX軸方向へ何パーセント移動したか（移動割合）を計算する
            currentMoveXPercentFromCenter = min(xPositionFromCenter / UIScreen.main.bounds.size.width, 1)
            
            // 中心位置からのY軸方向へ何パーセント移動したか（移動割合）を計算する
            currentMoveYPercentFromCenter = min(yPositionFromCenter / UIScreen.main.bounds.size.height, 1)
            
         //上記で算出したX軸方向の移動割合から回転量を取得し、初期配置時の回転量へ加算した値でアファイン変換を適用する
            
            let initialRotationAngle = atan2(initialTransform.b, initialTransform.a)
            let whenDraggingRotationAngel = initialRotationAngle + CGFloat.pi / 10 * currentMoveXPercentFromCenter
            let transforms = CGAffineTransform(rotationAngle: whenDraggingRotationAngel)
            
            // 拡大縮小比を適用する
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: maxScaleOfDragging, y: maxScaleOfDragging)
            self.transform = scaleTransform
            
            break
            
        // ドラッグ終了時の処理
        case .ended, .cancelled:
            
            // ドラッグ終了時点での速度を算出する
            let whenEndedVelocity = sender.velocity(in: self)
            
            //移動割合のしきい値を超えていた場合には、
            //画面外へ流れていくようにする（しきい値の範囲内の場合は元に戻る）
            
            let shouldMoveToLeft  = (currentMoveXPercentFromCenter < -swipeXPosLimitRatio && abs(currentMoveYPercentFromCenter) > swipeYPosLimitRatio)
            let shouldMoveToRight = (currentMoveXPercentFromCenter > swipeXPosLimitRatio && abs(currentMoveYPercentFromCenter) > swipeYPosLimitRatio)
            
            if shouldMoveToLeft {
                moveInvisiblePosition(verocity: whenEndedVelocity, isLeft: true)
            } else if shouldMoveToRight {
                moveInvisiblePosition(verocity: whenEndedVelocity, isLeft: false)
            } else {
                moveOriginalPosition()
            }
            
            // ドラッグ開始時の座標位置の変数をリセットする
            originalPoint = CGPoint.zero
            xPositionFromCenter = 0.0
            yPositionFromCenter = 0.0
            currentMoveXPercentFromCenter = 0.0
            currentMoveYPercentFromCenter = 0.0
            
            break
            
        default:
            break
        }
    }
    
    // このViewに対する初期設定を行う
    private func setupCardSetView() {
        //let resultViewController = ResultViewController()
        // カード状のViewに関する基本的な設定 ※設定できるパラメータは全てTinderCardDefaultSettings.swiftへ委譲している
        self.clipsToBounds   = true
        self.backgroundColor = DefaultSettings.backgroundColor
        self.frame = CGRect(
            origin: CGPoint.zero,
            size: CGSize(
                width:  DefaultSettings.cardSetViewWidth ,
                height: DefaultSettings.cardSetViewHeight
            )
        )
        
        //viewに関する詳細な設定
        self.layer.masksToBounds = false
        self.layer.borderColor   = DefaultSettings.backgroundBorderColor
        self.layer.borderWidth   = DefaultSettings.backgroundBorderWidth
        self.layer.cornerRadius  = DefaultSettings.backgroundCornerRadius
        self.layer.shadowRadius  = DefaultSettings.backgroundShadowRadius
        self.layer.shadowOpacity = DefaultSettings.backgroundShadowOpacity
        self.layer.shadowOffset  = DefaultSettings.backgroundShadowOffset
        self.layer.shadowColor   = DefaultSettings.backgroundBorderColor
    }
    
    // このViewのUIPanGestureRecognizerの付与を行う
    private func setupPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.startDragging))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    // このViewの初期状態での傾きと切片の付与を行う
    private func setupSlopeAndIntercept() {
        
        // 中心位置のゆらぎを表現する値を設定する
        let fluctuationsPosX: CGFloat = 0
        let fluctuationsPosY: CGFloat = 0
        
        // 基準となる中心点のX座標を設定する（デフォルトではデバイスの中心点）
        let initialCenterPosX: CGFloat = UIScreen.main.bounds.size.width / 2
        let initialCenterPosY: CGFloat = UIScreen.main.bounds.size.height / 2
        
        // 配置したViewに関する中心位置を算出する
        initialCenter = CGPoint(
            x: initialCenterPosX + fluctuationsPosX,
            y: initialCenterPosY + fluctuationsPosY
        )
        
        // 傾きのゆらぎを表現する値を設定する
        let fluctuationsRotateAngle: CGFloat = 0
        let angle = fluctuationsRotateAngle * .pi / 180.0 * 0.25
        initialTransform = CGAffineTransform(rotationAngle: angle)
        initialTransform.scaledBy(x: afterInitializeScale, y: afterInitializeScale)
        
        // カードの初期配置をするアニメーションを実行する
        moveInitialPosition()
    }
    
    // カードを初期配置する位置へ戻す
    private func moveInitialPosition() {
        
        // 表示前のカードの位置を設定する
      //  let beforeInitializePosX: CGFloat = CGFloat(Int.createRandom(range: Range(-300...300)))
       // let beforeInitializePosY: CGFloat = CGFloat(-Int.createRandom(range: Range(300...600)))
      // let beforeInitializeCenter = CGPoint(x: beforeInitializePosX, y: beforeInitializePosY)
        let beforeInitializeCenter = CGPoint(x: 0, y: 0)
        
        // 表示前のカードの傾きを設定する
       // let beforeInitializeRotateAngle: CGFloat = CGFloat(Int.createRandom(range: Range(-90...90)))
        let beforeInitializeRotateAngle: CGFloat = 0
        let angle = beforeInitializeRotateAngle * .pi / 180.0
        let beforeInitializeTransform = CGAffineTransform(rotationAngle: angle)
        beforeInitializeTransform.scaledBy(x: beforeInitializeScale, y: beforeInitializeScale)
        
        // 画面外からアニメーションを伴って現れる動きを設定する
        self.alpha = 1.0  //0.2
        self.center = beforeInitializeCenter
        self.transform = beforeInitializeTransform
        
       /* UIView.animate(withDuration: durationOfInitialize, animations: {
            self.alpha = 1
            self.center = self.initialCenter
            self.transform = self.initialTransform
        })*/
    }
    
    // カードを元の位置へ戻す
    private func moveOriginalPosition() {
        
        UIView.animate(withDuration: durationOfReturnOriginal, delay: 0.0, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {
            
            // ドラッグ処理終了時はViewのアルファ値を元に戻す
            self.alpha = self.stopDraggingAlpha
            
            // Viewの配置を元の位置まで戻す
            self.center = self.initialCenter
            self.transform = self.initialTransform
            
        }, completion: nil)
        
        // DelegeteメソッドのreturnToOriginalPositionを実行する
        self.delegate?.returnToOriginalPosition(self)
        
    }
    //カードを画面外に動かす
    private func moveInvisiblePosition(verocity: CGPoint, isLeft: Bool = true) {
        // 変化後の予定位置を算出する（Y軸方向の位置はverocityに基づいた値を採用する）
        let absPosX = UIScreen.main.bounds.size.width * 1.6
        let endCenterPosX = isLeft ? -absPosX : absPosX
        let endCenterPosY = verocity.y
        let endCenterPosition = CGPoint(x: endCenterPosX, y: endCenterPosY)
        
        UIView.animate(withDuration: durationOfSwipeOut, delay: 0.0, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {
            
            // ドラッグ処理終了時はViewのアルファ値を元に戻す
            self.alpha = self.stopDraggingAlpha
            
            // 変化後の予定位置までViewを移動する
            self.center = endCenterPosition
            
        }, completion: { _ in
           // print(self.delegate?.swipedRightPosition(self) as Any )
            // DelegeteメソッドのswipedLeftPositionを実行する
            let _ = isLeft ? self.delegate?.swipedLeftPosition(self) : self.delegate?.swipedRightPosition(self)
            //Used
            //self.delegate?.swipedRightPosition(self)
           // print(self.delegate?.swipedRightPosition(self) as Any )
        })
    }

}

