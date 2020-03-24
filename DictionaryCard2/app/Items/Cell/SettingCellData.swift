//
//  SettingCellData.swift
//  DictionaryCard2
//
//  Created by 東大地 on 2020/02/20.
//  Copyright © 2020 dachii. All rights reserved.
//

import Foundation
import UIKit

struct Setting {
    
    //Content of cells
    static let sectionList: [String] = ["About this app", "Card"]
    static let aboutThisAppList: [String] = ["License", "Contact"]
    static let cardList: [String] = ["Card1", "Card2", "Card3"]
    static let notificationList: [String] = ["Notification"]
    
    static let cardListFooter: String = ""
    //static let notificationFooter: String = "you can get quize each times you choose"
    //language
    
}


struct Language {
    
    static let language: [String] = ["Arabic (Saudi Arabia)", "Chinese (China)", "Chinese (Hong Kong SAR China)", "Chinese (Taiwan)", "Czech (Czech Republic)", "Danish (Denmark)", "Dutch (Belgium)", "Dutch (Netherlands)", "English (Australia)", "English (Ireland)", "English (South Africa)", "English (United Kingdom)", "English (United States)", "Finnish (Finland)", "French (Canada)", "French (France)", "German (Germany)", "Greek (Greece)", "Hebrew (Israel)", "Hindi (India)", "Hungarian (Hungary)", "Indonesian (Indonesia)", "Italian (Italy)", "Japanese (Japan)", "Korean (South Korea)", "Norwegian (Norway)", "Polish (Poland)", "Portuguese (Brazil)", "Portuguese (Portugal)", "Romanian (Romania)", "Russian (Russia)", "Slovak (Slovakia)", "Spanish (Mexico)", "Spanish (Spain)", "Swedish (Sweden)", "Thai (Thailand)", "Turkish (Turkey)"]
    
    static let languageCode: [String] = ["ar-SA", "zh-CN", "zh-HK", "zh-TW", "cs-CZ", "da-DK", "nl-BE", "nl-NL", "en-AU", "en-IE", "en-ZA", "en-GB", "en-US", "fi-FI", "fr-CA", "fr-FR", "de-DE", "el-GR", "he-IL", "hi-IN", "hu-HU", "id-ID", "it-IT", "ja-JP", "ko-KR", "no-NO", "pl-PL", "pt-BR", "pt-PT", "ro-RO", "ru-RU", "sk-SK", "es-MX", "es-ES", "sv-SE", "th-TH", "tr-TR"]
}

struct AboutThisApp {
    static let AboutThisApp: [String] = []
}

struct License {
    
    static let licenseTitle : [String] = ["icons8", "JOEmojiableBtn"]
    static let icon8 : String = "App icon by icon8(https://icons8.jp/)"
    static let JOEmojiableBtnLicense : [String] = ["Copyright (c) 2016 Jorge Ovalle <jroz9105@gmail.com>", "Released under the MIT license", "https://github.com/lojals/JOEmojiableBtn/blob/master/LICENSE"]
    
}

struct Contact {
    static let contact: [String] = ["Twitter"]
    static let twitter: [String] = ["@dachii_azm"]
}
