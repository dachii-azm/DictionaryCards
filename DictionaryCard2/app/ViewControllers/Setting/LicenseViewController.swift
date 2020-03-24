//
//  LisenceViewController.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2020/03/13.
//  Copyright © 2020 dachii. All rights reserved.
//
import Foundation
import UIKit


class LicenseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        configure()
        configureNavigationTitle()
    }
    
    private func configureNavigationTitle() {
        self.navigationItem.title = "License"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 20)!]
    }
}

//MARK Table View
extension LicenseViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Configure UITableView
    private func configureTableView() {
        let tableView: UITableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)!, width: self.view.bounds.width, height: self.view.bounds.height - (self.navigationController?.navigationBar.frame.size.height)!)
        tableView.delegate      =  self
        tableView.dataSource    =  self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "licenseCell")
        self.view.addSubview(tableView)
    }
    
       
    //configure all system
    private func configure() {
        configureTableView()
    }
    
   //number of section
    func numberOfSections(in tableView: UITableView) -> Int {
        return License.licenseTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if section == 0 {
            rows = 1
        } else if section == 1 {
            rows = License.JOEmojiableBtnLicense.count
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return License.licenseTitle[section]
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "licenseCell", for: indexPath)
           var text = ""
           if indexPath.section == 0 {
            text = License.icon8
           } else if indexPath.section == 1 {
            text = License.JOEmojiableBtnLicense[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        }
           cell.textLabel?.text = text
           return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: false)
        } else if indexPath.section == 1 {
            tableView.deselectRow(at: indexPath, animated: false)
            if indexPath.row == 2 {
                let url = URL(string: License.JOEmojiableBtnLicense[indexPath.row]) 
                UIApplication.shared.open(url!)
            }
        }
    }
}
