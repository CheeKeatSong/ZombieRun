//
//  missionTableViewCell.swift
//  HealthApp
//
//  Created by Song Chee Keat on 19/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit

class missionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var moneyImageView: UIImageView!
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var challengeStatus: UIImageView!
    @IBOutlet weak var mainObjectiveStatus: UIImageView!
    @IBOutlet weak var missionBackground: UIImageView!
    @IBOutlet weak var missionNameLabel: UILabel!
    @IBOutlet weak var mainObjectiveLabel: UILabel!
    @IBOutlet weak var missionIcon: UIImageView!
    @IBOutlet weak var challengeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        moneyImageView.tintColor = UIColor.green
        experienceImageView.tintColor = UIColor.green
        missionNameLabel.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.1)
        
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.missionBackground.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.alpha = 0.8
            
            missionBackground.addSubview(blurEffectView)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
