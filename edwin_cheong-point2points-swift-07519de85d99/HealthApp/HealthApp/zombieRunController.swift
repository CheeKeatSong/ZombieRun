//
//  zombieRunController.swift
//  HealthApp
//
//  Created by Song Chee Keat on 19/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit

class zombieRunController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = UIColor.init(red: 0.0, green: 102.0, blue: 0.0, alpha: 1.0)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.green], for:.selected)
        
        self.tabBar.barTintColor = UIColor.init(red: 13.0/255.0, green: 13.0/255.0, blue: 13.0/255.0, alpha: 1)
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
