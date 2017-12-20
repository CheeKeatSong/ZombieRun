//
//  LoginViewController.swift
//  HealthApp
//
//  Created by Edwin Cheong on 14/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var login = Login()
    
    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBAction func loginProfile(_sender:AnyObject!) {
        if checkIfEmpty() != false {
            login.userName = usernameTxtField.text
            login.password = passwordTextField.text
            
            if LoginHttpHelper.loginUser(model: login) != false {
                defer {
                    let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        // Your code with delay
                        self.clearTextField()
                        self.toDashBoard()
                    }
                }
            } else {
                print("Failed to login")
            }
        } else {
            self.clearTextField()
            displayAlertView(title: "Empty Fields", message: "Please fill in the missing fields", buttonMessage: "OK")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set layout method
        self.setButtonLayout()
        
        //Set ui components and background image
        self.setBackGroundImage()
        
        //Set transparent background effect
        self.setBlurEffect()
        
        //Hide Keyboard when tapped
        self.hideKeyBoardController()

        //Set app logo
        self.setAppLogoImage()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setAppLogoImage(){
        appLogoImageView.tintColor = UIColor.init(red: 0/255, green: 188/255, blue: 0/255, alpha: 1.0)
    }
    
    private func setButtonLayout() {
        registerButton.layer.cornerRadius = 5
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.white.cgColor
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setBackGroundImage() {
        passwordTextField.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.05)
        
        usernameTxtField.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.05)
        
        backgroundImageView.image = UIImage(named: "zombieApocalypse")
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFill
        backgroundImageView.clipsToBounds = true
    }
    
    private func setBlurEffect() {
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.alpha = 0.8
            
            backgroundImageView.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        }

    }
    
    private func displayAlertView(title:String,message:String,buttonMessage:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonMessage, style: UIAlertActionStyle.default, handler: { action in
            
            // do something like...
            self.clearTextField()
        }))
        present(alert,animated:true,completion:nil)
    }
    
    private func clearTextField() {
        self.usernameTxtField.text = ""
        self.passwordTextField.text = ""
        self.usernameTxtField.becomeFirstResponder()

    }
    
    private func toDashBoard() {
        if LoginCRUDHelper.getToken() != "" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Mission", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "tabView")
            self.show(vc, sender: self)
        } else {
            print("Empty Token Cannot Go Profile Page")
        }
    }
    
    private func checkIfEmpty() -> Bool{
        if usernameTxtField.text != "" && passwordTextField.text != "" {
            return true
        } else {
            return false
        }
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

