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
     let manager = AFHTTPSessionManager()
     static let sharedInstance = WebClientRequest(url: NSURL(string: SwipeRewardsAPI.serverURL)!, securityPolicy: AFSecurityPolicy(pinningMode: AFSSLPinningMode.none)) //PublicKey needs to change here
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
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
       // manager.requestSerializer.timeoutInterval = 100
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as? Set<String>
        manager.post((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, progress: nil, success:{
            (sessionTask, responseObject) -> () in
            success(responseObject! as AnyObject)
        }, failure:{
            (sessionTask, error) -> () in
            print(error)
            failure(error as NSError)} )

    }
    //Here we inititalze our AFNETWORKING
    func PostPathwithAUTH(urlString: String,
                 params: [String: AnyObject]?,
                 addToken: Bool = true,
                 successBlock success:@escaping (AnyObject) -> (),
                 failureBlock failure: @escaping (NSError) -> ()){
        
        
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as? Set<String>
        manager.requestSerializer.setValue(Database.value(forKey: Constants.Tokenkey) as? String, forHTTPHeaderField: "auth") //Change password header for auth
        manager.post((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: params, progress: nil, success:{
            (sessionTask, responseObject) -> () in
            success(responseObject! as AnyObject)
        }, failure:{
            (sessionTask, error) -> () in
            print(error)
            failure(error as NSError)} )
        
    }
    //Here we inititalze our AFNETWORKING
    func PostPathwithAUTH1(urlString: String,
                          params: [String: AnyObject]?,
                          addToken: Bool = true,
                          successBlock success:@escaping (AnyObject) -> (),
                          failureBlock failure: @escaping (NSError) -> ()){
        
        
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as? Set<String>
       // manager.requestSerializer.setValue(Database.value(forKey: Constants.Tokenkey) as? String, forHTTPHeaderField: "auth") //Change password header for auth
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
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func showActivityIndicator(vc: UIViewController) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = vc.view.center
        activityIndicator.center.y = activityIndicator.center.y - 60
        vc.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
    
    func postImage(urlString: String,
                   params: UIImage,
                   imageName: String,
                   addToken: Bool = true,
                   successBlock success:@escaping (AnyObject) -> (),
                   failureBlock failure: @escaping (NSError) -> ()){
        
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.securityPolicy.allowInvalidCertificates = true;
        manager.securityPolicy.validatesDomainName = false;
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as? Set<String>
        manager.requestSerializer.setValue(Database.value(forKey: Constants.Tokenkey) as? String, forHTTPHeaderField: "auth") //Change password header for auth
        var modifiedImage = params
        var imageExtension = ".png"
        var mimeTypeParam = "image/png"
        var imageData : Data!
        
        if let compressedImageData = UIImageJPEGRepresentation(modifiedImage, 0.6)
        {
            if let compressedImage = UIImage(data: compressedImageData)
            {
                modifiedImage = compressedImage
                imageExtension = ".jpg"
                mimeTypeParam = "image/jpg"
                imageData = compressedImageData
            }
            
        }
        if modifiedImage == params
        {
            if let pngImageData = UIImagePNGRepresentation(modifiedImage)
            {
                if let pngImage = UIImage(data: pngImageData)
                {
                    modifiedImage = pngImage
                    imageExtension = ".png"
                    mimeTypeParam = "image/png"
                    imageData = pngImageData
                }
            }
            
        }
        
        manager.post((NSURL(string: urlString, relativeTo: self.baseURL)?.absoluteString)!, parameters: nil, constructingBodyWith: { (formData) in
            //"image": "data:image/jpeg;base64"
            
            let imageData = UIImageJPEGRepresentation(modifiedImage, 0.5)
            
            let strBase64:String =  (imageData?.base64EncodedString(options: .lineLength64Characters))!
    
            print("Base64 :",strBase64)
            formData.appendPart(withFileData: imageData!, name: "file", fileName: imageName, mimeType: mimeTypeParam)
            
           
        }, progress: { (progress) in
            
        }, success: { (dataTask, response) in
            print("My Response : ", response ?? [String : AnyObject].self)
            self.updateprofileResponse(response: response as! [String : AnyObject])
           
           // success(imageExtension)
        }) { (dataTask, response) in
            failure(response as NSError)
        }
        
    }
    func updateprofileResponse(response: [String : AnyObject]){
        print("updateprofileResponse  :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
         
            Constants.profileimage = (response["responseData"]?.value(forKey: "imagePath") as? String)!
            Database.set(Constants.profileimage, forKey: Constants.profileimagekey)
            Database.synchronize()
        }else{
            
        }
        
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
