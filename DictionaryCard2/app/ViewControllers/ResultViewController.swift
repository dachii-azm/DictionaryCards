//
//  ResultViewController.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2019/12/20.
//  Copyright © 2019 dachii. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import AVFoundation

class ResultViewController: UIViewController, GADBannerViewDelegate {
    
    var selectWordList: [String] = [Key.WordList, Key.WordList2, Key.WordList3]
    var resultCardList: [ResultCardView] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        print(resultCardList.count)
        configure()
        addTextToWordList()
        addCardToList()
        deleteAllCards()
        showResultCardList()
        swipeGesture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViewController()
    }
    
    func updateViewController() {
        resultCardList.removeAll()
        loadView()
        viewDidLoad()
    }
    
    private func swipeGesture() {
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .right
        swipe.numberOfTouchesRequired = 2
        swipe.addTarget(self, action: #selector(self.swipeRight(sender: )))
        self.view.addGestureRecognizer(swipe)
    }
    
    @objc private func swipeRight(sender: Any) {
        self.tabBarController!.selectedIndex = 0
    }
}



//MARK Configure Items
extension ResultViewController {
    
    private func configureBottomAds() {
        var bottomBannerView = GADBannerView()
        bottomBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bottomBannerView, isBottom: true)
        bottomBannerView.rootViewController = self
        bottomBannerView.delegate = self
        // Set the ad unit ID to your own ad unit ID here.
        bottomBannerView.adUnitID = AdmobIDs.ResultBottomID
        bottomBannerView.load(GADRequest())
    }
    
    private func configureTopAds() {
        var topBannerView = GADBannerView()
        topBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(topBannerView, isBottom: false)
        topBannerView.rootViewController = self
        topBannerView.delegate = self
        // Set the ad unit ID to your own ad unit ID here.
        topBannerView.adUnitID = AdmobIDs.ResultTopID
        topBannerView.load(GADRequest())
    }
    
    private func configureTrashButton() {
        let trashButton = TrashButton()
        trashButton.addTarget(self, action: #selector(self.trashButtonTapped(sender: )), for: .touchUpInside)
        trashButton.frame = CGRect(x:0, y:0, width:Size.trashButtonWidth, height:Size.trashButtonHeight)
        trashButton.center = CGPoint(x: CGFloat.screenWidth()/2, y: CGFloat.screenHeight() * 4/5)
        self.view.addSubview(trashButton)
    }
    
    private func configureWordLists() {
        let wordList2: [String] = []
        let wordList3: [String] = []
        if UserDefaults.standard.object(forKey: Key.WordList2) == nil {
            UserDefaults.standard.set(wordList2, forKey: Key.WordList2)
        }
        if UserDefaults.standard.object(forKey: Key.WordList3) == nil {
            UserDefaults.standard.set(wordList3, forKey: Key.WordList3)
        }
    }
    
    private func configure() {
        configureWordLists()
        configureTopAds()
        configureBottomAds()
        configureTrashButton()
        configureNavigationBarItem()
    }
}

//MARK ADs position
extension ResultViewController {
    
    //avoid safe area
    func addBannerViewToView(_ bannerView: UIView, isBottom: Bool) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            if isBottom == true {
                positionBannerAtBottomOfSafeArea(bannerView)
            } else {
                positionBannerAtTopOfSafeArea(bannerView)
            }
        }
        else {
        }
    }
    
    @available (iOS 11, *)
    func positionBannerAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Centered horizontally.
        let guide: UILayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate(
            [bannerView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
             bannerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)]
        )
    }
    
    @available (iOS 11, *)
    func positionBannerAtTopOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Centered horizontally.
        let guide: UILayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate(
            [bannerView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
             bannerView.topAnchor.constraint(equalTo: guide.topAnchor)]
        )
    }
    
}

//MARK Button
extension ResultViewController {
    
    @objc func trashButtonTapped(sender: Any) {
        deleteFirstCard()
    }
    
    private func deleteFirstCard() {
        if resultCardList.first != nil {
            let index: Int = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
            var wordList: [String] = UserDefaults.standard.array(forKey: selectWordList[index]) as! [String]
            let i = wordList.firstIndex(of: (resultCardList.first!.Jplabel.text!))
            wordList.remove(at: i!)
            resultCardList.first!.removeFromSuperview()
            resultCardList.removeFirst()
            UserDefaults.standard.set(wordList, forKey: selectWordList[index])
        }
    }
    
    private func deleteAllCards() {
        if resultCardList.first != nil {
            for _ in 0..<resultCardList.count {
                resultCardList.first!.removeFromSuperview()
            }
        }
    }
    
   /* private func configureSiriButton(position: CGPoint) {
        let siriButton = UIButton()
        siriButton.frame.size = CGSize(width: 35, height: 50)
        siriButton.setImage(UIImage(named: PNG.siriIcon), for: .normal)
    }*/
    
    @objc func cardTapped(sender: Any) {
        self.present(getDictionary(), animated: false, completion: nil)
    }
}

//MARK WordList
extension ResultViewController {
    
    //text -> WordList
    private func addTextToWordList() {
        if UserDefaults.standard.object(forKey: Key.GetText) != nil {
            let index: Int = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
            var wordList: [String] = UserDefaults.standard.array(forKey: selectWordList[index]) as! [String]
            let word = UserDefaults.standard.object(forKey: Key.GetText) as! String
            UserDefaults.standard.removeObject(forKey: Key.GetText)
            if word.isEmpty {
            } else {
                deleteSameWord(wordList: &wordList, word: word)
            }
            UserDefaults.standard.set(wordList, forKey: selectWordList[index])
        }
    }
    
    private func deleteSameWord(wordList: inout [String], word: String) {
        wordList.insert(word, at: 0)
        let orderedSet = NSOrderedSet(array: wordList)
        wordList = orderedSet.array as! [String]
    }
    
    //WordList -> ResultCardList
    func addCardToList() {
        let index: Int = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
        let wordList: [String] = UserDefaults.standard.array(forKey: selectWordList[index]) as! [String]
        
        for index in 0..<wordList.count {
            let resultCardView = ResultCardView()
        //delegateにおいてめちゃ重要！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
            resultCardView.delegate = self
            resultCardView.Jplabel.text = wordList[index]
            
            if resultCardView.Jplabel.text!.isOnly(.decimalDigits, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' ") {
                let siriButton = UIButton()
                siriButton.frame.size = CGSize(width: 35, height: 50)
                siriButton.frame.origin = CGPoint(x:resultCardView.bounds.width - siriButton.frame.size.width - 10 ,y:10 )
                siriButton.setImage(UIImage(named: PNG.siriIcon), for: .normal)
                siriButton.addTarget(resultCardView, action: #selector(resultCardView.siriButtonTapped(sender: )), for: .touchUpInside)
                resultCardView.addSubview(siriButton)
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.cardTapped(sender: )))
            resultCardView.addGestureRecognizer(tap)
            resultCardView.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height * 2 / 5 + 50)
            self.resultCardList.append(resultCardView)
        }
    }
    
    private func configureWordList() {
        addTextToWordList()
        addCardToList()
    }
}

//MARK FlashCards
extension ResultViewController {
    //resultCardList内のviewを画面に描写する
    func showResultCardList() {
        
        
        for index in 0..<resultCardList.count {
            
            view.addSubview(resultCardList[index])
            view.sendSubviewToBack(resultCardList[index])
            
        }
        enableUserInteractionToFirstCardSetView()
        // 画面上にあるカードの山の拡大縮小比を調節する
        changeScaleToCardSetViews(skipSelectedView: false)
    }
    
    // 画面上にあるカードの山のうち、一番上にあるViewのみを操作できるようにする
    fileprivate func enableUserInteractionToFirstCardSetView() {
        if !resultCardList.isEmpty {
            if let firstCardView = resultCardList.first {
                firstCardView.isUserInteractionEnabled = true
            }
        }
    }
    
    fileprivate func changeScaleToCardSetViews(skipSelectedView: Bool = false) {
        //resultCardViewとは
        // アニメーション関連の定数値
        let duration: TimeInterval = 0.26
        let reduceRatio: CGFloat   = 0.018
        
        var targetCount: CGFloat = 0
        for (targetIndex, resultCardView) in resultCardList.enumerated() {
            
            // 現在操作中のViewの縮小比を変更しない場合は、以降の処理をスキップする
            if skipSelectedView && targetIndex == 0 { continue }
            
            // 後ろに配置されているViewほど小さく見えるように縮小比を調節する
            let targetScale: CGFloat = 1 - reduceRatio * targetCount
            UIView.animate(withDuration: duration, animations: {
                resultCardView.transform = CGAffineTransform(scaleX: targetScale, y: targetScale)
            })
            targetCount += 1
        }
    }
    
    func sendCardToBack(card: ResultCardView) {
        card.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height * 2 / 5 + 50)
        self.view.sendSubviewToBack(card)
    }
    
}


//MARK Dictionary
extension ResultViewController {
   
    //identify word represented in dictionary
    func getDictionary() -> UIReferenceLibraryViewController {
        if resultCardList.first!.Jplabel.text != nil {
            let word: String = resultCardList.first!.Jplabel.text!
            let dictionaryVC: UIReferenceLibraryViewController = UIReferenceLibraryViewController(term: word)
            return dictionaryVC
        } else {
            let noWordVC: UIReferenceLibraryViewController = UIReferenceLibraryViewController(term: "")
            return noWordVC
        }
    }
}

//MARK CardDelegate
extension ResultViewController: CardDelegate {
    // ドラッグ処理が開始された際にViewController側で実行する処理
    func beganDragging(_ cardView: ResultCardView) {
        changeScaleToCardSetViews(skipSelectedView: true)
    }
    
    // ドラッグ処理中に位置情報が更新された際にViewController側で実行する処理
    func updatePosition(_ cardView: ResultCardView, centerX: CGFloat, centerY: CGFloat) {
    }

    // 右方向へのスワイプが完了した際にViewController側で実行する処理
    func swipedRightPosition(_ cardView: ResultCardView) {
        enableUserInteractionToFirstCardSetView()
        let index: Int = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
        var wordList: [String] = UserDefaults.standard.array(forKey: selectWordList[index]) as! [String]
        wordList.append(resultCardList.first!.Jplabel.text!)
        wordList.removeFirst()
        UserDefaults.standard.set(wordList, forKey: selectWordList[index])
        resultCardList.append(resultCardList.first!)
        sendCardToBack(card: resultCardList.first!)
        resultCardList.removeFirst()
        changeScaleToCardSetViews(skipSelectedView: false)
    }
    
    // 右方向へのスワイプが完了した際にViewController側で実行する処理
    func swipedLeftPosition(_ cardView: ResultCardView) {
        enableUserInteractionToFirstCardSetView()
        let index: Int = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
        var wordList: [String] = UserDefaults.standard.array(forKey: selectWordList[index]) as! [String]
        wordList.append(resultCardList.first!.Jplabel.text!)
        wordList.removeFirst()
        UserDefaults.standard.set(wordList, forKey: selectWordList[index])
        resultCardList.append(resultCardList.first!)
        sendCardToBack(card: resultCardList.first!)
        resultCardList.removeFirst()
        changeScaleToCardSetViews(skipSelectedView: false)
    }
    

    // 元の位置へ戻った際にViewController側で実行する処理
    func returnToOriginalPosition(_ cardView: ResultCardView) {
    changeScaleToCardSetViews(skipSelectedView: false)
    }
}

//MARK UINavigationBar
extension ResultViewController {
    
    private func configureListButton() {
        var listButton = UIBarButtonItem()
        listButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.listButtonTapped(sender: )))
        self.navigationItem.rightBarButtonItem = listButton
    }
    
    @objc private func listButtonTapped(sender: Any) {
        let nextVC = ListViewController()
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    private func configureNavigationTitle() {
        let selectCardNumber = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
        let num = selectCardNumber + 1
        self.navigationItem.title = "Card\(num)"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 20)!]
    }
    
    private func configureNavigationBarItem() {
        configureNavigationTitle()
        configureListButton()
    }
}
