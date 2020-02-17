//
//  ViewController.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2019/12/20.
//  Copyright © 2019 dachii. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import JOEmojiableBtn
import ChameleonFramework

class SearchViewController: UIViewController, UITextFieldDelegate, GADBannerViewDelegate,  JOEmojiableDelegate {
    
    var selectWordList: [String] = [Key.WordList, Key.WordList2, Key.WordList3]
    var selectCardImage = [PNG.card1, PNG.card2, PNG.card3]
    var searchField = SearchField()
    var selectCardButton = JOEmojiableBtn(frame: CGRect(origin: CGPoint(x: 40, y: CGFloat.screenHeight()*7/10), size: CGSize(width: 70, height: 70)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        configure()
        swipeGesture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchField.text! = ""
    }
    
    private func swipeGesture() {
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .left
        swipe.numberOfTouchesRequired = 2
        swipe.addTarget(self, action: #selector(self.swipeLeft(sender: )))
        self.view.addGestureRecognizer(swipe)
    }
    
    @objc private func swipeLeft(sender: Any) {
        self.tabBarController!.selectedIndex = 1
    }
}

//MARK Configure Items
extension SearchViewController {
    
    //Configure SearchField
    private func configureSearchField() {
        self.searchField.delegate = self
        self.searchField.frame = CGRect(x:0 ,y:0, width:Size.searchFieldWidth, height: Size.searchFieldHeight)
        self.searchField.center = CGPoint(x: CGFloat.screenWidth()/2, y: CGFloat.screenHeight()/3)
        self.view.addSubview(self.searchField)
    }
    
    //Configure SearchLabel
    private func configureSearchButton() {
        let searchButton = SearchButton()
        searchButton.addTarget(self, action: #selector(self.searchButtonTapped(sender: )), for: .touchUpInside)
        searchButton.frame = CGRect(x:0,y:0,width:Size.searchButtonWidth,height:Size.searchButtonHeight)
        searchButton.center = CGPoint(x:CGFloat.screenWidth()/2, y:CGFloat.screenHeight()/2)
        self.view.addSubview(searchButton)
    }
    
    private func configureBottomAds() {
        var bannerView = GADBannerView()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView, isBottom: true)
        bannerView.rootViewController = self
        bannerView.delegate = self
        // Set the ad unit ID to your own ad unit ID here.
        bannerView.adUnitID = AdmobIDs.SearchBottomID
        bannerView.load(GADRequest())
    }
    
    private func configureTopAds() {
        var topBannerView = GADBannerView()
        topBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(topBannerView, isBottom: false)
        topBannerView.rootViewController = self
        topBannerView.delegate = self
        // Set the ad unit ID to your own ad unit ID here.
        topBannerView.adUnitID = AdmobIDs.SearchTopID
        topBannerView.load(GADRequest())
    }
    
    private func configureSelectCardsButton() {
        let optionsDataset = [
            JOEmojiableOption(image: PNG.card1, name: "card1"),
            JOEmojiableOption(image: PNG.card2, name: "card2"),
            JOEmojiableOption(image: PNG.card3, name: "card3")
        ]
       // let text = UserDefaults.standard.object(forKey: Key.SelectCard) as! String
        selectCardButton.delegate = self
        //selectCardButton.backgroundColor = .blue
        selectCardButton.dataset = optionsDataset
        //selectCardButton.setTitle(text, for: .normal)
        //selectCardButton.setTitleColor(.black, for: .normal)
        let index = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
        selectCardButton.setImage(UIImage(named:selectCardImage[index]), for: .normal)
        //selectCardButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        selectCardButton.layer.cornerRadius = 20
        selectCardButton.layer.borderColor = UIColor.black.cgColor
        selectCardButton.layer.borderWidth = 3
        selectCardButton.contentMode = UIView.ContentMode.scaleAspectFit
        selectCardButton.contentHorizontalAlignment = .fill
        selectCardButton.contentVerticalAlignment = .fill
        self.view.addSubview(selectCardButton)
    }
    
    private func configureSelectCardLabel() {
        let selectCardLabel = UILabel()
        selectCardLabel.text = "Change Cards"
        selectCardLabel.font = UIFont.systemFont(ofSize: 15)
        selectCardLabel.textColor = .black
        selectCardLabel.frame = CGRect(x: 40, y: CGFloat.screenHeight()*7/10 - 20, width: 100, height: 50)
        selectCardLabel.sizeToFit()
        selectCardLabel.textAlignment = .center
        self.view.addSubview(selectCardLabel)
    }
    
    //Configure all of Items
    private func configure() {
        configureSearchField()
        configureSearchButton()
        configureBottomAds()
        configureTopAds()
        configureSelectCardLabel()
        configureSelectCard()
        configureSelectCardsButton()
        configureNavigationBarItem()
    }
}


//MARK Action of SearchButton
extension SearchViewController {
    
    //Action of Search Button Tapped
    @objc private func searchButtonTapped(sender: Any) {
        let index: Int = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
        var wordList: [String] = UserDefaults.standard.array(forKey: selectWordList[index]) as! [String]
        identifyGetText(wordList: &wordList)
    }
    
    //judge whether GetText is nil of not
    private func identifyGetText(wordList: inout [String]) {
        if UserDefaults.standard.object(forKey: Key.GetText) != nil {
            let word: String = UserDefaults.standard.object(forKey: Key.GetText) as! String
            removeObject(key: Key.GetText)
            identifyWord(word: word, wordList: &wordList)
            openDictionary(word: word)
        }
        else {
        }
    }
    
    //judge whether word is nil or not
    private func identifyWord(word: String, wordList: inout [String]) {
        if word.isEmpty {
        } else {
            wordList.insert(word, at: 0)
            let index: Int = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
            UserDefaults.standard.set(deleteSameWords(wordList: wordList), forKey: selectWordList[index])
        }
    }
    
    //delete same words in wordList
    private func deleteSameWords(wordList: [String]) -> [String] {
        let orderedSet = NSOrderedSet(array: wordList)
        let orderedList = orderedSet.array as! [String]
        return orderedList
    }
    
    private func openDictionary(word: String) {
        let ref: UIReferenceLibraryViewController = UIReferenceLibraryViewController(term: word )
        self.present(ref, animated: false, completion: nil)
    }
    
    private func dictionaryHasPages(word: String) -> Bool {
        return UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word)
    }

}



//MARK Extension
extension SearchViewController {
    
    //remove UserDefaultSetting
    private func removeObject(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
}

//MARK Detail of KeyField
extension SearchViewController {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text! = ""
    }
    
    //close Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
       
    //if push other space、close Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.searchField.isFirstResponder) {
            self.searchField.resignFirstResponder()
        }
    }
       
    //Load after editing UITextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaults.standard.set(textField.text!, forKey: Key.GetText)
    }
}

//SelectCardButton
extension SearchViewController {
    
    func selectedOption(_ sender: JOEmojiableBtn, index: Int) {
        
        var selectCardNumber = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
        if selectCardNumber == index {
            print("Same as Select Cards")
        } else {
            selectCardNumber = index
            UserDefaults.standard.set(selectCardNumber, forKey: Key.SelectCardNumber)
            //selectCardButton.setTitle("a", for: .normal)
            selectCardButton.setImage(UIImage(named:selectCardImage[index]), for: .normal)
            
        }
    }
    
    func cancelledAction(_ sender: JOEmojiableBtn) {
    }
    
    private func configureSelectCard() {
        if UserDefaults.standard.object(forKey: Key.SelectCardNumber) != nil {
        } else {
            let selectCardNumber: Int = 0
            UserDefaults.standard.set(selectCardNumber, forKey: Key.SelectCardNumber)
        }
    }
}

//MARK ADs position
extension SearchViewController {
    
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

//MARK UINavigationBar
extension SearchViewController {
    
    private func configureSettingButton() {
        var settingButton = UIBarButtonItem()
        settingButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.settingButtonTapped(sender: )))
        self.navigationItem.leftBarButtonItem = settingButton
    }
    
    @objc private func settingButtonTapped(sender: Any) {
        let nextVC = SettingViewController()
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    private func configureNavigationTitle() {
        self.navigationItem.title = "Search"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 20)!]
    }
    
    private func configureNavigationBarItem() {
        configureNavigationTitle()
        configureSettingButton()
    }
}

