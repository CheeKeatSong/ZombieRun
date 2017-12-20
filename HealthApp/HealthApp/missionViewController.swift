//
//  missionViewController.swift
//  HealthApp
//
//  Created by Song Chee Keat on 19/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher
import ESPullToRefresh

class missionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet var missionTableView: UITableView!
    
    var data = MissonCRUDHelper.findAll()
    var executed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if executed == false {
            self.setBackgroundImage()
            
            self.setBannerImage()
        }
        
        self.reloadTable()
    }
    
    private func reloadTable() {
        let table = self.missionTableView.es_addPullToRefresh {
            [weak self] in
            /// Do anything you want...
            MissionHttpHelper.getMissions()
            
            defer {
                let when = DispatchTime.now() + 3 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    // Your code with delay
                    self?.data = MissonCRUDHelper.findAll()
                    self?.missionTableView.reloadData()
                    
                    /// Stop refresh when your job finished, it will reset refresh footer if completion is true
                    self?.missionTableView.es_stopPullToRefresh(ignoreDate: true)
                    /// Set ignore footer or not
                    self?.missionTableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
                }
            }
        }
        
        if table.isRefreshing {
            print("Refreshing")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MissionHttpHelper.getMissions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data.count
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "missionCell", for: indexPath) as! missionTableViewCell
        
        data.reverse()
        
        // Configure and populate data
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.missionNameLabel.text = data[indexPath.row].missonTitle
        cell.mainObjectiveLabel.text = data[indexPath.row].missionObjective
        cell.challengeLabel.text = data[indexPath.row].missionChallenge
        
        cell.moneyLabel.text = data[indexPath.row].missionMoney
        cell.experienceLabel.text = data[indexPath.row].missionExp
        
        let url = URL(string: data[indexPath.row].missionBanner!)
        cell.missionBackground.kf.setImage(with: url)
        cell.missionBackground.contentMode = UIViewContentMode.scaleAspectFill
        cell.missionBackground.clipsToBounds = true
        
//        url = URL(string: data[indexPath.row].missionIcon!)	
//        cell.missionIcon.kf.setImage(with: url)
        cell.missionIcon.image = #imageLiteral(resourceName: "zombieHand")
        cell.missionIcon.contentMode = UIViewContentMode.scaleAspectFill
        cell.missionIcon.clipsToBounds = true

        
        //boolean to determine objective status of a mission, var status in mission object for your case.
//        let status = true;
        
        /*
        cell.mainObjectiveStatus.image = UIImage(named:"tickMark")
        cell.mainObjectiveStatus.tintColor = UIColor.green

        cell.challengeStatus.image = UIImage(named:"tickMark")
        cell.challengeStatus.tintColor = UIColor.green
        */
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDetail", sender: nil)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let indexPath: NSIndexPath = self.missionTableView.indexPathForSelectedRow! as NSIndexPath
        
        if segue.identifier == "ShowDetail" {
            let navVC = segue.destination as! UINavigationController
            let detailVC = navVC.topViewController as! missionDetailsViewController
            detailVC.missionData = data[indexPath.row]
        }
    }

}

extension missionViewController {
    public func setBannerImage() {
        
        
        bannerImageView.image = UIImage(named: "bioHazard")
        bannerImageView.contentMode = UIViewContentMode.scaleAspectFill
        bannerImageView.clipsToBounds = true
        
            //Do something here
            //only apply the blur if the user hasn't disabled transparency effects
            if !UIAccessibilityIsReduceTransparencyEnabled() {
                
                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                //always fill the view
                blurEffectView.frame = self.view.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurEffectView.alpha = 0.85
                
                bannerImageView.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
            }
    }
    
    public func setBackgroundImage() {
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "zombieApocalypse")
        let imageView = UIImageView(image: backgroundImage)
        
        // center and scale background image
        imageView.contentMode = .scaleAspectFill
        
        missionTableView.backgroundView = imageView
        
        
        //Do something here
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.alpha = 0.85
            
            imageView.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        }
    }
}
