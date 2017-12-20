//
//  userProfileViewController.swift
//  HealthApp
//
//  Created by Song Chee Keat on 19/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit
import EZLoadingActivity
import JSQWebViewController

class userProfileViewController: UIViewController {
    
    var loginData: LoginDataModel! = LoginCRUDHelper.find()
    var baseButtonValue = 0
    var addZombieButtonValue = 10
    
    // Temp data for user, change database by adding two column(baseLevel, zombieNumber)
    var money = 0
    var baseLevel = 1
    var zombieNumber = 0
    
    @IBOutlet weak var updateNumberButton: UIButton!
    @IBOutlet weak var updateBaseButton: UIButton!
    @IBOutlet weak var baseLabel: UILabel!
    @IBOutlet weak var zombieNumberLabel: UILabel!
    @IBOutlet weak var increaseZombieNumberButton: UIButton!
    @IBOutlet weak var baseUpdateButton: UIButton!
    @IBOutlet weak var rankView: UIView!
    @IBOutlet weak var zombieNumberImageView: UIImageView!
    @IBOutlet weak var baseImageView: UIImageView!
    @IBOutlet weak var rankImageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var userRecordSection: UIView!
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var aboutUsButton: UIButton!
    @IBOutlet weak var achievementButton: UIButton!
    @IBOutlet weak var CurrencyImageView: UIImageView!
    @IBOutlet weak var experienceImageView: UIImageView!
    @IBOutlet weak var totalDistanceStackView: UIStackView!
    @IBOutlet weak var totalTimeStackView: UIStackView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var totalDistanceImageView: UIImageView!
    @IBOutlet weak var totalTimeImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var experienceProgressView: UIProgressView!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var imgProfilePic:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set layout method
        self.setUIComponents()
        
        //Set ui components and background image
        self.setBackGroundImage()
        
        //Set transparent background effect
        self.setBlurEffect()
        
        //Sets data from db to textfield
        self.setData()
        
        self.addTapGesture()
        
        //Hide Keyboard when tapped
        self.hideKeyBoardController()
        
        //Set user base status
        self.setBaseStatus()
    }
    
    //Runs portion when the user interacts with the screen
    override func viewDidAppear(_ animated: Bool) {
        loginData = LoginCRUDHelper.find()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Upload to server after screen has dissapeear
        /*let login = LoginDataModel()
        let link = "https://api.backendless.com/B4344DD7-F3DF-4BA3-FFC4-5699F23F1900/v1/files/profilePic/" + usernameTxtField.text! + ".png"
        login.userName = usernameTxtField.text
        login.profilePic = link
        login.objectID = loginData.objectID
        login.userToken = loginData.userToken
//        login.userExp = Int64(experienceLabel.text!)!
//        login.userLevel = Int64(levelLabel.text!)!
        login.userMoney = Int64(money)
        login.userTotalDistance = Double(totalDistanceLabel.text!)!
        login.userBaseLevel = Int64(baseLevel)
        login.userZombieNumber = Int64(zombieNumber)
 
        LoginHttpHelper.postUpdateUser(user: login)*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func upgradeBase(_ sender: UIButton) {
        if baseLevel < 6 {
            if baseButtonValue < money {
                baseLevel += 1 // update database base level
                money = money - baseButtonValue // update database user money
                moneyLabel.text = String(money)
                setBaseStatus()
                            }else{
                displayAlertView(title: "Failed to upgrade", message: "Please hunt more brain to upgrade your base!", buttonMessage: "OK")
            }
        }else{
            displayAlertView(title: "Max Level Reached", message: "The base is already at max level. Congratulations!", buttonMessage: "OK")
        }
    }
    
    @IBAction func upgradeZombieNumber(_ sender: UIButton) {
        if addZombieButtonValue < money {
            zombieNumber += 1 // update database base level
            money = money - addZombieButtonValue // update database user money
            moneyLabel.text = String(money)
            setBaseStatus()
        }else{
            displayAlertView(title: "Failed to recruit", message: "Please hunt more brain to recruit more brethren!", buttonMessage: "OK")
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        self.logOutUser()
    }
    
    @IBAction func aboutUsPage(_ sender:Any) {
        let controller = WebViewController(url: URL(string: "https://www.facebook.com/point2points/?ref=aymt_homepage_panel")!)
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.optionsMenu))
        imgProfilePic.addGestureRecognizer(tap)
        imgProfilePic.isUserInteractionEnabled = true
    }
    
    private func displayAlertView(title:String,message:String,buttonMessage:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonMessage, style: UIAlertActionStyle.default, handler: { action in
        }))
        present(alert,animated:true,completion:nil)
    }
    
    //MARK: - Delegates
    //When it returns a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        // what to do with your image?
        Utilities.transformToCircularImage(imageView: imgProfilePic)
        imgProfilePic.image = image
        
        if LoginHttpHelper.uploadProfilePic(profilePic: image, picName: usernameTxtField.text!) != false {
           print("Uploaded")
        } else {
           print("Not Uploaded") 
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //No photo selected
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("No photo selected")
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

extension userProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func optionsMenu() {
        let camera = Camera(delegate_: self)
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Camera", style: .default) { (alert : UIAlertAction!) in
            camera.presentPhotoCamera(target: self, isEditable: true)
        }
        let sharePhoto = UIAlertAction(title: "Library", style: .default) { (alert : UIAlertAction) in
            camera.presentPhotoLibrary(target: self, isEditable: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction) in
            //
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        
        optionMenu.addAction(cancel)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    public func logOutUser() {
        LoginCRUDHelper.delete()
        self.toLoginPage()
    }
    
    public func toLoginPage() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "UserAuthentication", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LoginView")
        self.show(vc, sender: self)
    }
    
    public func setData() {
        if Utilities.isObjectNil(object: loginData as AnyObject!) != false {
            let zombiePic = "https://api.backendless.com/B4344DD7-F3DF-4BA3-FFC4-5699F23F1900/v1/files/profilePic/zombie.png"
            
            // give distinct experiece capacity
            var experienceCap = 0
            for _ in 1...(describing: loginData.userLevel!) {
                experienceCap += 100
            }

            totalDistanceLabel.text = String(loginData.userTotalDistance) + " km"
            usernameTxtField.text = loginData.userName!
            levelLabel.text = "Level " + String(describing: loginData.userLevel!)
            experienceLabel.text = String(describing: loginData.userExp!) + "/" + String(experienceCap)
            moneyLabel.text = String(describing: loginData.userMoney!)
            totalDistanceLabel.text = String(describing: loginData.userTotalDistance!) + " KM"
            experienceProgressView.progress = Float(loginData.userExp)
            baseLevel = Int(loginData.userBaseLevel)
            zombieNumber = Int(loginData.userZombieNumber)
            money = Int(loginData.userMoney)
            
            if loginData.profilePic != zombiePic {
                let url = URL(string: loginData.profilePic)
                Utilities.transformToCircularImage(imageView: imgProfilePic)
                imgProfilePic.kf.setImage(with: url)
            } else {
                imgProfilePic.image = #imageLiteral(resourceName: "zombieProfile")
            }
        } else {
            print("My object is nil")
        }
    }
    
    public func setBackGroundImage() {
        backgroundImageView.image = UIImage(named: "zombieApocalypse")
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFill
        backgroundImageView.clipsToBounds = true
    }
    
    public func setBlurEffect() {
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
    
    public func setBaseStatus(){
        var baseText = ""
        switch baseLevel {
        case 1:
            baseText = "Zombie Slum"
            baseUpdateButton.setTitle("100", for: .normal)
            baseButtonValue = 100
        case 2:
            baseText = "Zombie Village"
            baseUpdateButton.setTitle("200", for: .normal)
            baseButtonValue = 200
        case 3:
            baseText = "Zombie Town"
            baseUpdateButton.setTitle("300", for: .normal)
            baseButtonValue = 300
        case 4:
            baseText = "Zombie Stronghold"
            baseUpdateButton.setTitle("400", for: .normal)
            baseButtonValue = 400
        case 5:
            baseText = "Zombie City"
            baseUpdateButton.setTitle("500", for: .normal)
            baseButtonValue = 500
        case 6:
            baseText = "Zombie Castle"
            baseUpdateButton.setTitle("MAX", for: .normal)
        default:
            baseText = "Zombie Slum"
        }
        baseLabel.text = baseText
        zombieNumberLabel.text = String(zombieNumber)
        
        if zombieNumber > 8 && baseLevel > 1{
            rankLabel.text = "Zombie"
            rankImageView.image = #imageLiteral(resourceName: "zombieFace")
        }else{
            rankLabel.text = "Zombie Baby"
            rankImageView.image = #imageLiteral(resourceName: "baby")
        }
        if zombieNumber > 15 && baseLevel > 2 {
            rankLabel.text = "Zombie Warrior"
            rankImageView.image = #imageLiteral(resourceName: "shield")
        }
        if zombieNumber > 30 && baseLevel > 3 {
            rankLabel.text = "Zombie Knight"
            rankImageView.image = #imageLiteral(resourceName: "sword")
        }
        if zombieNumber > 60 && baseLevel > 4 {
            rankLabel.text = "Zombie General"
            rankImageView.image = #imageLiteral(resourceName: "roman-helmet")
        }
        if zombieNumber > 100 && baseLevel > 5 {
            rankLabel.text = "Zombie King"
            rankImageView.image = #imageLiteral(resourceName: "crown")
        }
    }
    
    public func setUIComponents() {
        increaseZombieNumberButton.layer.cornerRadius = 5
        baseUpdateButton.layer.cornerRadius = 5
        baseUpdateButton.backgroundColor = UIColor.green
        increaseZombieNumberButton.backgroundColor = UIColor.green
        rankImageView.tintColor = UIColor.green
        zombieNumberImageView.tintColor = UIColor.green
        baseImageView.tintColor = UIColor.green
        rankView.backgroundColor = UIColor.init(white: 1, alpha: 0.1)
        userRecordSection.backgroundColor = UIColor.init(white: 1, alpha: 0.1)
        levelImageView.tintColor = UIColor.green
        logOutButton.tintColor = UIColor.green
        achievementButton.tintColor = UIColor.green
        aboutUsButton.tintColor = UIColor.green
        achievementButton.backgroundColor = UIColor.init(white: 1, alpha: 0.1)
        aboutUsButton.backgroundColor = UIColor.init(white: 1, alpha: 0.1)
        logOutButton.backgroundColor = UIColor.init(white: 1, alpha: 0.1)
        CurrencyImageView.tintColor = UIColor.green
        experienceImageView.tintColor = UIColor.green
        totalDistanceImageView.tintColor = UIColor.green
        totalTimeImageView.tintColor = UIColor.green

        experienceProgressView.transform = experienceProgressView.transform.scaledBy(x: 1, y: 1)
        experienceProgressView.layer.cornerRadius = 5
        experienceProgressView.clipsToBounds = true
        
        usernameTxtField.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.05)
    }
}
