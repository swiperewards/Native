//
//  Constants.swift
//  Swipe Rewards
//
//  Created by Bharathan on 24/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit

class Constants: NSObject {
    static let ConstantsharedInstance = Constants()
    
    static let Networkerror = "Please check your Internet Connection!"
    static let NetworkerrorTitle = "Network Connectivity"
    static let errInvalidEmail   = "Please enter valid email id"
    static let errPassword = "Password is not matching"
    static let errInvalidPassword = "8 char long,1 upper & 1 Special"
    static let errEmailexits = "Email Already Exists"
    static let emptyEmail = "Email is required"
    static let emptyFirstname = "First name is required"
    static let emptyLastname = "Last name is required"
    static let emptyPassword = "Password is required"
    static let emptyConfirmPassword = "Confirm Password is required"
    static let emptyOldPassword = "Old Password is required"
    static let emptynewPassword = "New Password is required"
    //Default Placeholder
    static let Email   = "Email ID"
    static let Firstname = "Firstname"
    static let Lastname = "Lastname"
    static let Password = "Password"
    static let ConfirmPassword = "Confirm Password"
    static let OldPassword = "Old Password"
    static let NewPassword = "New Password"
    
    static let emptyCardNumber = "Card Number is required"
    static let emptyExpiry = "Expiry on is required"
    static let emptyCvv = "CVV is required"
    static let emptyNameonCard = "Name on Card is required"

    static let CardNumber = "Card Number"
    static let Expiry = "Expiry on"
    static let Cvv = "CVV"
    static let NameonCard = "Name on Card"
    
    //DB
    static var Token = String()
    static let Tokenkey = "Auth"
    
    //DB
    static var fcmToken = String()
    static let fcmTokenkey = "fcm"
    
    //DB
    static var profileimage = String()
    static let profileimagekey = "Profile"
    
    static var cityname = String()
    static let citynamekey = "cityname"
    
    static var searchcityname = String()
    static let searchcitynamekey = "searchcityname"
    
    static var WalletBalance = String()
    static let WalletBalancekey = "WalletBalance"
    
    //DB
    static var Termsofuse = String()
    static let Termsofusekey = "Termsofuse"
    //DB
    static var Privacy = String()
    static let Privacykey = "Privacy"
    
    static var Username = String()
    static let UsernameKey = "User"
 //   static var cardID = [String]()
    static var cardIDkey = "CardID"
    
    
    static var Newrecord = Int()
    static let NewrecordKey = "NewrecordKey"
    
    
    static var DealnameSearch = Int()
    static let DealnameSearchKey = "DealnameSearchKey"
    
    static var mycode = String()
    static let mycodeKey = "mycodeKey"
    
    
    static var minlevel = Int()
    static let minlevelKey = "minlevel"
    
    static var maxlevel = Int()
    static let maxlevelKey = "maxlevel"
    
    static var level = Int()
    static let levelKey = "level"
    
    static var userlevel = Float()
    static let userlevelKey = "userlevel"
    
    static var Montharray = [Int]()
    static let MontharrayKey = "MontharrayKey"
    
    static var GoogleIdentityforchangepassword = String()
    static let GoogleIdentityforchangepasswordkey = "GoogleIdentityforchangepassword"
    

    
}
