//
//  FontSwipe.swift
//  Swipe Rewards
//
//  Created by Bharathan on 03/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift

class FontSwipe: NSObject {
    
    
    
        enum FontSwipe: String {
        case Username = "\u{e811}"
        case Wallet = "\u{e800}"
        case Backarrow = "\u{e801}"
        case Close = "\u{e802}"
        case Camera = "\u{e803}"
        case Contact = "\u{e804}"
        case Awardcup = "\u{e805}"
        case Arrowdown = "\u{e806}"
        case Arrowupword = "\u{e807}"
        case Password = "\u{e808}"
        case History = "\u{e809}"
        case Privacysecurity = "\u{e80a}"
        case Downarrow  = "\u{e80b}"
        case Notification = "\u{e80c}"
        case Phone = "\u{e80d}"
        case Home = "\u{e80e}"
        case Email = "\u{e80f}"
        case Edit = "\u{e810}"
        case Signout = "\u{e812}"
        case Rightclick = "\u{e813}"
        case Setting = "\u{e814}"
        case Termsofuse = "\u{e815}"
        case Transfer = "\u{e816}"
        case Tearch = "\u{e817}"
        case Redeem = "\u{e818}"
        }
    let FontSwipeIcons : Dictionary = [
        "username" : "\u{e811}",
        "wallet" : "\u{e800}",
        "backarrow" : "\u{e801}",
        "close" : "\u{e802}",
        "camera" : "\u{e803}",
        "contact" : "\u{e804}",
        "awardcup" : "\u{e805}",
        "arrowdown" : "\u{e806}",
        "arrowupword" : "\u{e807}",
        "password" : "\u{e808}",
        "history" : "\u{e809}",
        "privacysecurity" : "\u{e80a}",
        "downarrow" : "\u{e80b}",
        "notification" : "\u{e80c}",
        "phone" : "\u{e80d}",
        "home" : "\u{e80e}",
        "email" : "\u{e80f}",
        "edit" : "\u{e810}",
        "signout" : "\u{e812}",
        "rightclick" : "\u{e813}",
        "setting" : "\u{e814}",
        "termsofuse" : "\u{e815}",
        "transfer" : "\u{e816}",
        "search" : "\u{e817}",
        "redeem" : "\u{e818}",
        ]
    
    func fontOfSize(_ fontSize: CGFloat) -> UIFont {
        return Fontello.fontOfSize(fontSize, name: "swipe")
    }
    func stringWithName(_ name: FontSwipe) -> String {
        return name.rawValue.substring(to: name.rawValue.characters.index(name.rawValue.startIndex, offsetBy: 1))
    }
    func stringWithCode(_ code: String) -> String? {
        guard let raw = FontSwipeIcons[code], let icon = FontSwipe(rawValue: raw) else {
            return nil
        }
        return self.stringWithName(icon)
    }
}



