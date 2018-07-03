//
//  FontSwipeLogo.swift
//  Swipe Rewards
//
//  Created by Bharathan on 03/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift
class FontSwipeLogo: NSObject {

    enum FontSwipeLogo: String {
        case Swipelogo = "\u{e800}"}
    let FontSwipeLogoIcons : Dictionary = [
        "swipelogo" : "\u{e800}",]
    func fontOfSize(_ fontSize: CGFloat) -> UIFont {
        return Fontello.fontOfSize(fontSize, name: "swipelogo")}
    func stringWithName(_ name: FontSwipeLogo) -> String {
        return name.rawValue.substring(to: name.rawValue.characters.index(name.rawValue.startIndex, offsetBy: 1))}
    func stringWithCode(_ code: String) -> String? {
        guard let raw = FontSwipeLogoIcons[code], let icon = FontSwipeLogo(rawValue: raw) else {
            return nil}
        return self.stringWithName(icon)}
}
