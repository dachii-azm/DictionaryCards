//
//  ContactViewController.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2020/03/13.
//  Copyright © 2020 dachii. All rights reserved.
//

import Foundation
import UIKit


class ContactViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        configure()
    }
    
    private func configureNavigationTitle() {
        self.navigationItem.title = "Contact"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 20)!]
    }
    
}

//MARK Table View
extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Configure UITableView
    private func configureTableView() {
        let tableView: UITableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)!, width: self.view.bounds.width, height: self.view.bounds.height - (self.navigationController?.navigationBar.frame.size.height)!)
        tableView.delegate      =  self
        tableView.dataSource    =  self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "contactCell")
        self.view.addSubview(tableView)
    }
    
       
    //configure all system
    private func configure() {
        configureTableView()
    }
    
   //number of section
    func numberOfSections(in tableView: UITableView) -> Int {
        return Contact.contact.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = Contact.twitter.count
        return rows
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Contact.contact[section]
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        cell.textLabel?.text = Contact.twitter[indexPath.row]
           return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let twitterURL = "https://twitter.com/dachii_azm"
        let url = URL(string: twitterURL)
        UIApplication.shared.open(url!)
    }
    
    
}
