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
    
    //http://192.168.0.198:5000/
    
    //
    
    //
    static let serverURL = "http://34.238.120.25:5008/"
    static let signUpURL = "users/registerUser"
    static let signInURL = "users/loginUser"
    static let ChangePasswordURL = "users/changePassword"
    static let DealsURL = "deals/getDealsWithPaging"
    static let AddCardURL = "user/cards/addCard"
    static let GetCardURL = "user/cards/getCards"
    static let DeleteCardURL = "user/cards/deleteCard"
    static let GetRedeemURL = "redeem/getRedeemOptions"
    static let RaiseRedeemURL = "redeem/raiseRedeemRequest"
    static let InitSwipeURL = "config/initSwipe"
    static let EventHistoryURL = "event/getEventNotifications"
    static let GetTicketsURL = "tickets/getTicketTypes"
    static let SendTicketsURL = "tickets/generateTicket"
    static let UploadImageURL = "users/updateProfilePic"
    static let ForgotPasswordURL = "users/forgotPassword"
    static let ResetPasswordURL = "users/setPassword"
    static let GetcityURL = "config/getCities"
    static let ApplyreferralcodeURL = "users/applyReferralCode"
    static let Firebasenotification = "notifications/addUpdateFcmToken"
    
    //config/getCities
    
    ////
    
    //http://host:5000/deals/getDealsWithPaging
    
    ///http://winjitstaging.cloudapp.net:5000/public/ProfileImages/uid42-8B1EC230-9B81-4B32-9590-90B71421DBDA.jpeg
    
    
}
