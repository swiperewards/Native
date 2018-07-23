//
//  WebClientRequest.swift
//  Swipe Rewards
//
//  Created by Bharathan on 23/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import AFNetworking
let RequestManager = WebClientRequest.sharedInstance
class WebClientRequest: AFHTTPSessionManager {
    
    static let sharedInstance = WebClientRequest(url: NSURL(string: SwipeRewardsAPI.serverURL)!, securityPolicy: AFSecurityPolicy(pinningMode: AFSSLPinningMode.none))
    convenience init(url: NSURL, securityPolicy: AFSecurityPolicy){
        self.init(baseURL: url as URL)
        self.securityPolicy = securityPolicy
        }
    //Here we inititalze our AFNETWORKING
    func getPath(urlString: String,
                 params: [String: AnyObject]?,
                 addToken: Bool = true,
                 successBlock success:@escaping (AnyObject) -> (),
                 failureBlock failure: @escaping (NSError) -> ()){
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as? Set<String>
        manager.post((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, progress: nil, success:{
            (sessionTask, responseObject) -> () in
            success(responseObject! as AnyObject)
        }, failure:{
            (sessionTask, error) -> () in
            print(error)
            failure(error as NSError)} )

    }
    // Call get request method
    func getRequesct(url: String, paramD: [String: AnyObject], successBlock success:@escaping ([String: AnyObject]) -> (),failureBlock failure:@escaping (NSError) -> ()){
        self.getPath(urlString: url, params: paramD, successBlock:
        { (response) -> () in print(response)}){
            (error: NSError) ->() in failure(error)}
        }
    
    /*
     //Get method
     //        manager.get((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, progress: nil, success:{
     //            (sessionTask, responseObject) -> () in
     //            success(responseObject! as AnyObject)
     //        },failure:{
     //            (sessionTask, error) -> () in
     //            print(error)
     //            failure(error as NSError)})
     */

}
