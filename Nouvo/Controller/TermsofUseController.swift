//
//  TermsofUseController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 08/08/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import WebKit
class TermsofUseController: UIViewController,WKNavigationDelegate {
var indicator = UIActivityIndicatorView()
    var webView : WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
         setUpNavBar()
        let myBlog = (Database.value(forKey: Constants.Termsofusekey) as? String)!
        let url = URL(string: myBlog)
        let request = URLRequest.init(url: url!)
        // init and load request in webview.
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        webView.load(request)
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
        // Do any additional setup after loading the view.
    }
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.white
        self.navigationItem.title = "TERMS OF USE"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        view.addSubview(indicator)
        indicator.frame = view.bounds
        indicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
         indicator.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- WKNavigationDelegate
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
