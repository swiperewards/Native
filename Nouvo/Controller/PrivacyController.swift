//
//  PrivacyController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 06/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import WebKit


class PrivacyController: UIViewController,WKNavigationDelegate {

    var webView : WKWebView!
    var indicator = UIActivityIndicatorView()
    @IBOutlet weak var PrivacyIcon5: UILabel!
    @IBOutlet weak var PrivacyIcon4: UILabel!
    @IBOutlet weak var PrivacyIcon3: UILabel!
    @IBOutlet weak var PrivacyIcon2: UILabel!
    @IBOutlet weak var PrivacyIcon1: UILabel!
    @IBOutlet weak var Privacycontent5: UILabel!
    @IBOutlet weak var Privacycontent4: UILabel!
    @IBOutlet weak var PrivacyContent3: UILabel!
    @IBOutlet weak var Privacycontent2: UILabel!
    @IBOutlet weak var Privacycontent1: UILabel!
    
     //MARK: - Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        let myBlog = (Database.value(forKey: Constants.Privacykey) as? String)!
        let url = URL(string: myBlog)
        let request = URLRequest.init(url: url!)
        // init and load request in webview.
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        webView.load(request)
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
        setUpNavBar()
    }
     //MARK: - Webview Delegate
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //print("Strat to load")
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        view.addSubview(indicator)
        indicator.frame = view.bounds
        indicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // print("finish to load")
         indicator.removeFromSuperview()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.white
        self.navigationItem.title = "PRIVACY & SECURITY"
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
}
