//
//  AppDelegate.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2019/12/20.
//  Copyright © 2019 dachii. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var WordList: [String] = [NSLocalizedString("ThisIs", comment: ""), NSLocalizedString("FlashCards", comment: ""), NSLocalizedString("YouCan", comment: ""), NSLocalizedString("AddWords", comment: ""), NSLocalizedString("YouSearched", comment: ""), NSLocalizedString("AndDelete", comment: ""), NSLocalizedString("ByPushing", comment: ""), NSLocalizedString("TrashButton", comment: "")]
    var selectCardNumber: Int = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
            // Override point for customization after application launch.
            // ここに初期化処理を書く
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        //アプリID
       GADMobileAds.configure(withApplicationID: "ca-app-pub-2263975696621022~4566562713")
        //GADMobileAds.configure(withApplicationID: "1:143132813666:ios:3c2754cd2db25ff8")
            // UserDefaultsを使ってフラグを保持する
            let userDefault = UserDefaults.standard
            // "firstLaunch"をキーに、Bool型の値を保持する
            let dict = ["firstLaunch": true]
            // デフォルト値登録
            // ※すでに値が更新されていた場合は、更新後の値のままになる
            userDefault.register(defaults: dict)
            
            // "firstLaunch"に紐づく値がtrueなら(=初回起動)、値をfalseに更新して処理を行う
            if userDefault.bool(forKey: "firstLaunch") {
                userDefault.set(false, forKey: "firstLaunch")
                UserDefaults.standard.set(WordList, forKey: Key.WordList)
                UserDefaults.standard.set(selectCardNumber, forKey: Key.SelectCardNumber)
                //let wordList: [String] = UserDefaults.standard.array(forKey: Data.WordList) as! [String]
                print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
                print("初回起動の時だけ呼ばれるよ")
            }
            
           // print("初回起動じゃなくても呼ばれるアプリ起動時の処理だよ")
            
            return true
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

