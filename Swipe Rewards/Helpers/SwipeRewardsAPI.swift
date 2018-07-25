//
//  SwipeRewardsAPI.swift
//  Swipe Rewards
//
//  Created by Bharathan on 18/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.


//Swipe Rewards Server Request API
import UIKit
class SwipeRewardsAPI: NSObject {
static let sharedInstance = SwipeRewardsAPI()
    static let serverURL = "http://winjitstaging.cloudapp.net:5000/"
    static let signUpURL = "users/registerUser"
    static let signInURL = "users/loginUser"
    static let ChangePasswordURL = "users/changePassword"
    static let DealsURL = "deals/getDeals"
}
