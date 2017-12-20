//
//  missionDetailsViewController.swift
//  HealthApp
//
//  Created by Song Chee Keat on 20/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit
import Kingfisher

class missionDetailsViewController: UIViewController {

    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var moneyImageView: UIImageView!
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var missionStartButton: UIButton!
    @IBOutlet weak var missionIconImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var missionTitle: UILabel!
    @IBOutlet weak var missionDetail: UILabel!
    @IBOutlet weak var mainObjectiveStatus: UIImageView!
    @IBOutlet weak var mainObjectiveLabel: UILabel!
    @IBOutlet weak var challengeStatus: UIImageView!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var playTimeImageView: UIImageView!
    @IBOutlet weak var distanceImageView: UIImageView!
    
    var missionData = Selection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUIComponents()
        self.setBackgroundImage()
        self.setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToMainScreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MissionSegue" {
            let detailVC = segue.destination as! inMissionViewController;
            detailVC.data = missionData
        }
    }
}

extension missionDetailsViewController {
    public func setData() {
        missionTitle.text = missionData.missonTitle
        missionDetail.text = missionData.missionObjective
        distanceLabel.text = missionData.missionDistance
        mainObjectiveLabel.text = missionData.missionObjective
        challengeLabel.text = missionData.missionChallenge
        experienceLabel.text = missionData.missionExp
        moneyLabel.text = missionData.missionMoney
        playTimeLabel.text = missionData.missionTime
        
        /*mainObjectiveStatus.image = UIImage(named:"tickMark")
        mainObjectiveStatus.contentMode = UIViewContentMode.scaleAspectFill
        mainObjectiveStatus.clipsToBounds = true
        	
        challengeStatus.image = UIImage(named:"tickMark")
        challengeStatus.contentMode = UIViewContentMode.scaleAspectFill
        challengeStatus.clipsToBounds = true
        */
        
        missionIconImageView.image = #imageLiteral(resourceName: "zombieHand")
        
        missionIconImageView.contentMode = UIViewContentMode.scaleAspectFill
        missionIconImageView.clipsToBounds = true
        
        missionStartButton.layer.cornerRadius = 5
        var url = URL(string: missionData.missionBanner!)
        bannerImageView.kf.setImage(with: url)
        bannerImageView.contentMode = UIViewContentMode.scaleAspectFill
        bannerImageView.clipsToBounds = true
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.alpha = 0.8
            bannerImageView.addSubview(blurEffectView)
        }
    }
    
    public func setUIComponents(){
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 44.0/255.0, green: 44.0/255.0, blue: 44.0/255.0, alpha: 1.0 )
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(red: 0.0/255.0, green: 188.0/255.0, blue: 0.0/255.0, alpha: 1.0 )]
        
        playTimeImageView.tintColor = UIColor.green
        distanceImageView.tintColor = UIColor.green
        
        missionStartButton.layer.cornerRadius = 5
        
        experienceImageView.tintColor = UIColor.green
        
        moneyImageView.tintColor = UIColor.green
    }
    
    public func setBackgroundImage(){
        backgroundImageView.image = UIImage(named: "zombieApocalypse")
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.alpha = 0.85
            backgroundImageView.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        }
    }
}
