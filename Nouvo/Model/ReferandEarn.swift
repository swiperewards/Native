//
//  ReferandEarn.swift
//  Nouvo
//
//  Created by Bharathan on 07/09/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift
class ReferandEarn: NSObject {
    enum ReferandEarn: String {
        case Referandearn = "\u{E800}"}
    let ReferandEarnIcons : Dictionary = [
        "referandearn" : "\u{E800}",]
    func fontOfSize(_ fontSize: CGFloat) -> UIFont {
        return Fontello.fontOfSize(fontSize, name: "referandearn")}
    func stringWithName(_ name: ReferandEarn) -> String {
        return name.rawValue.substring(to: name.rawValue.characters.index(name.rawValue.startIndex, offsetBy: 1))}
    func stringWithCode(_ code: String) -> String? {
        guard let raw = ReferandEarnIcons[code], let icon = ReferandEarn(rawValue: raw) else {
            return nil}
        return self.stringWithName(icon)}
}
