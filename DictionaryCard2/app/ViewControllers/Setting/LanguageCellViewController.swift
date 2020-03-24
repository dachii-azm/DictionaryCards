//
//  LanguageCellViewController.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2020/03/09.
//  Copyright © 2020 dachii. All rights reserved.
//

import Foundation
import UIKit


class LanguageCellViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        configure()
        configureNavigationTitle()
    }
    
    private func configureNavigationTitle() {
        self.navigationItem.title = "Language"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 20)!]
    }
    
}

//MARK Table View
extension LanguageCellViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Configure UITableView
    private func configureTableView() {
        let tableView: UITableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)!, width: self.view.bounds.width, height: self.view.bounds.height - (self.navigationController?.navigationBar.frame.size.height)!)
        tableView.delegate      =  self
        tableView.dataSource    =  self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "languageCell")
        self.view.addSubview(tableView)
    }
    
       
    //configure all system
    private func configure() {
        configureTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Language.language.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Language"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath)
        cell.textLabel?.text = Language.language[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        UserDefaults.standard.set(Language.languageCode[indexPath.row], forKey: cellTapped())
        self.navigationController?.popViewController(animated: true)
    }
    
    func cellTapped() -> String {
        let languageIndex: Int = UserDefaults.standard.object(forKey: Key.LanguageIndex) as! Int
        let forKey: String = "card\(languageIndex+1)Language"
        return forKey
    }
}
