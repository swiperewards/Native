//
//  CardIconFont.swift
//  Nouvo
//
//  Created by Bharathan on 04/09/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift
class CardIconFont: NSObject {
    enum CardIconFont: String {
        case Cardicon = "\u{E800}"}
    let CardIconFontIcons : Dictionary = [
        "cardicon" : "\u{E800}",]
    func fontOfSize(_ fontSize: CGFloat) -> UIFont {
        return Fontello.fontOfSize(fontSize, name: "cardicon")}
    func stringWithName(_ name: CardIconFont) -> String {
        return name.rawValue.substring(to: name.rawValue.characters.index(name.rawValue.startIndex, offsetBy: 1))}
    func stringWithCode(_ code: String) -> String? {
        guard let raw = CardIconFontIcons[code], let icon = CardIconFont(rawValue: raw) else {
            return nil}
        return self.stringWithName(icon)}
}
