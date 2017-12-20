
//
//  achievementViewController.swift
//  HealthApp
//
//  Created by Song Chee Keat on 02/04/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit

class achievementViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var achievementCollectionView: UICollectionView!
    
    let reuseIdentifier = "achievementCell" // also enter this string as the cell identifier in the storyboard
    var achievementItems = [["sword", "First Blood", "You are beginning a new life of abdomination!", "Hunt a human!", "true"], ["shield", "Zombie Warrior", "You are a warrior! BRAINSSS!!", "Own the status of a Zombie Warrior in your profile.", "false"], ["brainMoney","Human Eater", "Brain Brain Brain, never tired of brain.", "Hunt 30 humans.", "false"] ,["tickMark","First Trial","We should always be willing to give a try.","Complete a mission and it's challenge objective","true"]]

    override func viewDidLoad() {
        super.viewDidLoad()

        setBackgroundImage()
        setUIComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.achievementItems.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! achievementCollectionViewCell
        
        cell.achievementLabel.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.1)
        cell.achievementImageView.image = UIImage(named: self.achievementItems[indexPath.item][0])
        cell.achievementLabel.text = self.achievementItems[indexPath.item][1]
        
        if self.achievementItems[indexPath.item][4] == "false" {
            
            cell.achievementImageView.tintColor = UIColor.darkGray
            cell.achievementLabel.textColor = UIColor.white
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        displayAlertView(title: achievementItems[indexPath.item][1], message: achievementItems[indexPath.item][2] + "\n\n" + achievementItems[indexPath.item][3], buttonMessage: "OK")
    }
    
    @IBAction func backToProfilePage(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func displayAlertView(title:String,message:String,buttonMessage:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonMessage, style: UIAlertActionStyle.default, handler: { action in
        }))
        present(alert,animated:true,completion:nil)
    }
    
    private func setUIComponents(){
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 44.0/255.0, green: 44.0/255.0, blue: 44.0/255.0, alpha: 1.0 )
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(red: 0.0/255.0, green: 188.0/255.0, blue: 0.0/255.0, alpha: 1.0 )]
    }
    
    private func setBackgroundImage(){
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "zombieApocalypse")
        let imageView = UIImageView(image: backgroundImage)
        
        // center and scale background image
        imageView.contentMode = .scaleAspectFill
        
        achievementCollectionView.backgroundView = imageView
        
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
