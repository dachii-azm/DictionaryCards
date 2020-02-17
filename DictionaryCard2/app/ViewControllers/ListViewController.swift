//
//  ListViewController.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2019/12/20.
//  Copyright © 2019 dachii. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    
    var wordArray: [String] = []
    var selectWordList: [String] = [Key.WordList, Key.WordList2, Key.WordList3]
    var tableView = UITableView()
    var sortedWordList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        chooseWordList()
        configure()
        
    }
    
    private func chooseWordList() {
        let index = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
        self.wordArray = UserDefaults.standard.array(forKey: selectWordList[index]) as! [String]
    }
    
}

//MARK Configure
extension ListViewController {
    
    func configureTableView() {
        
        self.tableView = UITableView()
        self.tableView.frame         =  CGRect(x: 0, y: (self.navigationController?.navigationBar.bounds.height)!, width: CGFloat.screenWidth(), height: CGFloat.screenHeight() - (self.navigationController?.navigationBar.bounds.height)!)
        //self.tableView.center = CGPoint(x: CGFloat.screenWidth()/2, y: CGFloat.screenHeight()/2)
        self.tableView.delegate      =  self
        self.tableView.dataSource    =  self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
    }
    
    func configure() {
        sortWordList(wordList: wordArray)
        configureTableView()
        configureNavigationItems()
    }
}

//MARK List
extension ListViewController {
    
    //sort in alphabet
    func sortWordList(wordList: [String]) {
        self.sortedWordList = wordList.sorted { $0 < $1 }
    }
    
    
}

//MARK Cell
extension ListViewController {
    
    //present dictionary when Tapped
    func cardTapped(index: Int, wordList: [String]) {
        openDictionary(word: sortedWordList[index])
    }
    
    //get choosed word Index
    func choosedWordNumber(index: Int, wordList: [String]) -> Int {
        let chooseNumber: Int = wordList.firstIndex(of: sortedWordList[index] as String )!
        return chooseNumber
    }
    
    //remove choosed word
    func removeWord(index: Int, wordList: inout [String]) {
        wordList.remove(at: choosedWordNumber(index: index, wordList: wordList))
        UserDefaults.standard.set(wordList, forKey: Key.WordList)
    }
    
    
}

//MARK Ads
extension ListViewController {
    
    //calculate Number of Ads
    private func calculateNumOfAds() -> Int {
        let NumOfAd: Int = Int(floor(Double(sortedWordList.count / 10))) + 1
        return NumOfAd
    }
    
    private func configureBottomAds() {
        var bannerView = GADBannerView()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.rootViewController = self
        bannerView.delegate = self
        // Set the ad unit ID to your own ad unit ID here.
        bannerView.adUnitID = AdmobIDs.ListID
        bannerView.load(GADRequest())
    }
}

//MARK UITableView
extension ListViewController {
    
    //number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedWordList.count + calculateNumOfAds()
    }
    
    //context of cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = self.sortedWordList[indexPath.row]
        return cell
    }
    
    //action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cardTapped(index: indexPath.row, wordList: self.wordArray)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    //slide
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeWord(index: indexPath.row, wordList: &self.wordArray)
            self.sortedWordList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

//MARK Dictionary
extension ListViewController {
    
    private func openDictionary(word: String) {
        let ref: UIReferenceLibraryViewController = UIReferenceLibraryViewController(term: word )
        self.present(ref, animated: false, completion: nil)
    }
    
    private func dictionaryHasPages(word: String) -> Bool {
        return UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word)
    }
}

//MARK NavigationBar
extension ListViewController {
    
    //set shuffleButton
    private func configureShuffleButton() {
        var shuffleButton = UIBarButtonItem()
        shuffleButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.shuffleButtonTapped(sender: )))
        self.navigationItem.rightBarButtonItems = []
        self.navigationItem.rightBarButtonItems?.append(shuffleButton)
    }
    
    //action of shuffleButton
    @objc private func shuffleButtonTapped(sender: Any) {
        self.sortedWordList = self.sortedWordList.shuffled()
        self.tableView.reloadData()
    }
    
    private func configureAZButton() {
        var AZButton = UIBarButtonItem()
        AZButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.AZButtonTapped(sender: )))
        self.navigationItem.rightBarButtonItems?.append(AZButton)
    }
    
    @objc private func AZButtonTapped(sender: Any) {
        self.sortedWordList = self.sortedWordList.sorted { $0 < $1 }
        self.tableView.reloadData()
    }
    
    //set title
    private func configureNavigationTitle() {
        let selectCardNumber = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
        let num = selectCardNumber + 1
        self.navigationItem.title = "Card\(num)"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 20)!]
    }
    
    
    
    private func configureNavigationItems() {
        configureShuffleButton()
        configureAZButton()
        configureNavigationTitle()
    }
    
}
