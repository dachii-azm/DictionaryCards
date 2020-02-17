//
//  ResultNavigationController.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2020/02/16.
//  Copyright © 2020 dachii. All rights reserved.
//

import Foundation
import UIKit

class ResultNavigationController: UINavigationController, TabBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didSelectTab(tabBarController: MainTabBarController) {
        popToRootViewController(animated: false)
    }
}
