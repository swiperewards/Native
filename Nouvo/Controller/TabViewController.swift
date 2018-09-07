//
//  TabViewController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 06/08/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import SDWebImage

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        
       // UITabBar.appearance().selectionIndicatorImage = UIImage(named: "Top_bg")
        
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor(red: 0/255, green: 166/255, blue: 242/255, alpha: 1), size: tabBarItemSize).resizableImage(withCapInsets: .zero)
        
        // remove default border
        tabBar.frame.size.width = self.view.frame.width + 6
        tabBar.frame.origin.x = 0

        
        

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

