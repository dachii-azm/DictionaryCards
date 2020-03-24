//
//  SettingViewController.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2020/02/14.
//  Copyright © 2020 dachii. All rights reserved.
//

import Foundation
import UIKit


class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var segment: UISegmentedControl = UISegmentedControl()
    var notificationWord: String = ""
    var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        configure()
        configureNavigationTitle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    //use NavigationController and move to next VC
    private func moveToNextVC(VC: UIViewController) {
        navigationController?.pushViewController(VC, animated: true)
    }
    
    private func configureNavigationTitle() {
        self.navigationItem.title = "Setting"
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 20)!]
    }
}


//MARK Notification
extension SettingViewController {
    
    //ユーザーに通知許可をもらう
    private func notificationRequest() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Allowed")
            } else {
                print("Didn't allowed")
            }
        }
    }
    
    private func configureNotification() {
         let seconds = Int(segment.titleForSegment(at: segment.selectedSegmentIndex)!)!
        
        // content
        let content = UNMutableNotificationContent()
        content.title = "It's time to study words!"
        //content.subtitle = "\(seconds) seconds elapsed!"
        content.body = "Do you remember the meaning of \(self.notificationWord)"
        content.sound = UNNotificationSound.default
        
        // trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(seconds),
                                                        repeats: false)

        // request includes content & trigger
        let request = UNNotificationRequest(identifier: "TIMER\(seconds)",
                                            content: content,
                                            trigger: trigger)

        // schedule notification by adding request to notification center
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

//MARK Table View
extension SettingViewController {
    
    //number of section
    func numberOfSections(in tableView: UITableView) -> Int {
        return Setting.sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if section == 0 {
            rows = Setting.aboutThisAppList.count
        } else if section == 1 {
            rows = Setting.cardList.count
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Setting.sectionList[section]
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let footerList: [String] = ["","If you set the language of flash cards,Siri allow you to speech the words."]
        return footerList[section]
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingCellView
        var text = ""
        if indexPath.section == 0 {
            text = Setting.aboutThisAppList[indexPath.row]
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        } else if indexPath.section == 1 {
            let key: String = "card\(indexPath.row+1)Language"
            text = Setting.cardList[indexPath.row]
            cell.languageLabel.text = (UserDefaults.standard.object(forKey: key) as! String)
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
        
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let viewControllers: [UIViewController] = [LicenseViewController(), ContactViewController()]
            self.moveToNextVC(VC: viewControllers[indexPath.row])
            tableView.deselectRow(at: indexPath, animated: false)
        } else if indexPath.section == 1 {
            UserDefaults.standard.set(indexPath.row, forKey: Key.LanguageIndex)
            self.moveToNextVC(VC: LanguageCellViewController())
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

//MARK Configure
extension SettingViewController {
    //Configure UITableView
    private func configureTableView() {
        tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)!, width: self.view.bounds.width, height: self.view.bounds.height - (self.navigationController?.navigationBar.frame.size.height)!)
        tableView.delegate      =  self
        tableView.dataSource    =  self
        tableView.register(SettingCellView.self, forCellReuseIdentifier: "settingCell")
        self.view.addSubview(tableView)
    }
    
    //configure all system
    private func configure() {
        configureTableView()
    }
}

