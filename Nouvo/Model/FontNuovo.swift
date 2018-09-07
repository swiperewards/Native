//
//  FontNuovo.swift
//  Nouvo
//
//  Created by Bharathan on 04/09/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift
class FontNuovo: NSObject {

    enum FontNuovo: String {
        case Nuovo = "\u{0200}"}
    let FontNuovoIcons : Dictionary = [
        "nuovo" : "\u{0200}",]
    func fontOfSize(_ fontSize: CGFloat) -> UIFont {
        return Fontello.fontOfSize(fontSize, name: "nuovo")}
    func stringWithName(_ name: FontNuovo) -> String {
        return name.rawValue.substring(to: name.rawValue.characters.index(name.rawValue.startIndex, offsetBy: 1))}
    func stringWithCode(_ code: String) -> String? {
        guard let raw = FontNuovoIcons[code], let icon = FontNuovo(rawValue: raw) else {
            return nil}
        return self.stringWithName(icon)}
}
