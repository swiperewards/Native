//
//  LocalDatabase.swift
//  Swipe Rewards
//
//  Created by Bharathan on 26/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit

let Database = LocalDatabase.sharedInstance
class LocalDatabase: UserDefaults {
static let sharedInstance = LocalDatabase.standard
    
    
    
    func ClearallLocalDB()  {
        let domain = Bundle.main.bundleIdentifier!
        Database.removePersistentDomain(forName: domain)
        Database.synchronize()
    }
}
