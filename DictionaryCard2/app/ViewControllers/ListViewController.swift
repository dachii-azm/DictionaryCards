//
//  ListViewController.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2019/12/20.
//  Copyright © 2019 dachii. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var wordArray: [String] = UserDefaults.standard.array(forKey: Key.WordList) as! [String]
    var tableView = UITableView()
    var sortedWordList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureTableView()
    }
    
    
    
}

//MARK Configure
extension ListViewController {
    
    func configureTableView() {
        self.tableView = UITableView()
        //tableView.frame         =  CGRect(x: screenWidth * 0.2, y: screenHeight * 0.1, width: screenWidth * 0.8, height: screenHeight * 0.9)
        self.tableView.delegate      =  self
        self.tableView.dataSource    =  self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
    }
    
    func configure() {
        configureTableView()
        sortWordList(wordList: wordArray)
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

//MARK UITableView
extension ListViewController {
    
    //number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedWordList.count
    }
    
    //context of cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = self.sortedWordList[indexPath.row]
        return cell
    }
    
    //action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cardTapped(index: indexPath.row, wordList: self.wordArray)
    }
    
    //slide
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeWord(index: indexPath.row, wordList: &self.wordArray)
            self.sortedWordList.remove(at: indexPath.row)
            //removeWord(index: indexPath.row)
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

