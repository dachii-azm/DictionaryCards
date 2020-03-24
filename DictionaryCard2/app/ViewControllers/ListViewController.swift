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

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate, UISearchBarDelegate {
    
    var bottomBannerView = GADBannerView()
    var wordArray: [String] = []
    var selectWordList: [String] = [Key.WordList, Key.WordList2, Key.WordList3]
    var tableView = UITableView()
    var sortedWordList: [String] = []
    var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        chooseWordList()
        configure()
        configureBottomAds()
    }
    
    private func chooseWordList() {
        let index = UserDefaults.standard.object(forKey: Key.SelectCardNumber) as! Int
        self.wordArray = UserDefaults.standard.array(forKey: selectWordList[index]) as! [String]
    }
}

//MARK Configure
extension ListViewController {
    
    private func configureSearchBar() {
        self.searchBar.delegate = self
        self.searchBar.placeholder  = "Search"
        self.searchBar.showsCancelButton = true
        self.searchBar.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!  , width: CGFloat.screenWidth(), height: 40)
        self.view.addSubview(searchBar)
    }
    
    private func configureTableView() {
        self.tableView = UITableView()
        self.tableView.frame =  CGRect(x: 0, y: self.searchBar.frame.maxY, width: CGFloat.screenWidth(), height: CGFloat.screenHeight() - self.searchBar.frame.maxY -
            (self.tabBarController?.tabBar.bounds.height)!)
        //self.tableView.center = CGPoint(x: CGFloat.screenWidth()/2, y: CGFloat.screenHeight()/2)
        self.tableView.delegate      =  self
        self.tableView.dataSource    =  self
        self.tableView.register(CustomCellView.self, forCellReuseIdentifier: "cell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Adcell")
        self.view.addSubview(self.tableView)
    }
    
    private func configure() {
        sortWordList(wordList: wordArray)
        configureNavigationItems()
        configureSearchBar()
        configureTableView()
    }
}

//MARK List
extension ListViewController {
    
    //sort in alphabet
    private func sortWordList(wordList: [String]) {
        self.sortedWordList = wordList.sorted { $0 < $1 }
    }
    
    
}

//MARK Cell
extension ListViewController {
    
    //present dictionary when Tapped
    private func cardTapped(index: Int, wordList: [String]) {
        openDictionary(word: sortedWordList[index])
    }
    
    //get choosed word Index
    private func choosedWordNumber(index: Int, wordList: [String]) -> Int {
        let chooseNumber: Int = wordList.firstIndex(of: sortedWordList[index] as String )!
        return chooseNumber
    }
    
    //remove choosed word
    private func removeWord(index: Int, wordList: inout [String]) {
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
        bottomBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bottomBannerView, isBottom: true)
        bottomBannerView.rootViewController = self
        bottomBannerView.delegate = self
        // Set the ad unit ID to your own ad unit ID here.
        bottomBannerView.adUnitID = AdmobIDs.ListID
        bottomBannerView.load(GADRequest())
    }
    
    private func addBannerViewToView(_ bannerView: UIView, isBottom: Bool) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            if isBottom == true {
                positionBannerAtBottomOfSafeArea(bannerView)
            } else {
                //positionBannerAtTopOfSafeArea(bannerView)
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
    
}

//MARK UITableView
extension ListViewController {
    
    
    //number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedWordList.count
    }
    
    //context of cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCellView
        cell.textLabel!.text = self.sortedWordList[indexPath.row]
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
        shuffleButton = UIBarButtonItem(image: UIImage(named: "shuffle"), style: .plain, target: self, action: #selector(self.shuffleButtonTapped(sender: )))
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
        AZButton = UIBarButtonItem(image: UIImage(named: "A-Z"), style: .plain, target: self, action: #selector(self.AZButtonTapped(sender: )))
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

//MARK searchBar
extension ListViewController {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let searchArray = self.sortedWordList.filter{$0.localizedCaseInsensitiveContains(self.searchBar.text!)}
        searchWordToFirst(searchArray: searchArray)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchBar.endEditing(true)
    }
    
    //sort cell according to search
    func searchWordToFirst(searchArray: [String]) {
        for value in searchArray {
            self.sortedWordList.remove(at: self.sortedWordList.firstIndex(of: value)!)
            self.sortedWordList.insert(value, at: 0)
        }
        self.tableView.reloadData()
    }
}
