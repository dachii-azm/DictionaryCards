//
//  TabBarDelegate.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2019/12/21.
//  Copyright © 2019 dachii. All rights reserved.
//

import Foundation

@objc protocol TabBarDelegate {
 
    func didSelectTab(tabBarController: MainTabBarController)
}
