//
//  RegisterViewController.swift
//  HealthApp
//
//  Created by Edwin Cheong on 14/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var register = Register()

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var registerCompleteButton: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword:UITextField!
//    @IBOutlet weak var profilePic:UIImageView!
    
    @IBAction func registerUser(_sender:AnyObject) {
        if self.checkIfEmpty() != false {
            register.regEmail = txtEmail.text
            register.regPassword = txtPassword.text
            register.regUserName = txtUserName.text
            register.regProfilePic = "https://api.backendless.com/B4344DD7-F3DF-4BA3-FFC4-5699F23F1900/v1/files/profilePic/zombie.png"
            
            if txtPassword.text == txtConfirmPassword.text  {
                if RegHttpHelper.postToUser(model: register) == true {
                    defer {
                        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            // Your code with delay
                            self.clearTextField()
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                } else {
                    self.clearTextField()
                    displayAlertView(title: "Login Failed", message: "Something went wrong with the server", buttonMessage: "OK")
                }
            } else {
                self.clearTextField()
                displayAlertView(title: "Password Mismatch", message: "Password does not match", buttonMessage: "OK")
            }
            
        } else {
            self.clearTextField()
            displayAlertView(title: "Empty Fields", message: "Please fill in the missing fields", buttonMessage: "OK")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUIComponents()
        self.setBackgroundImage()
        self.setBlurEffect()
        //Hide Keyboard when tapped
        self.hideKeyBoardController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToLoginPage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    private func setBackgroundImage() {
        backgroundImageView.image = UIImage(named: "zombieApocalypse")
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFill
        backgroundImageView.clipsToBounds = true
    }
    
    private func setUIComponents() {
        backButton.tintColor = UIColor.green
        
        registerCompleteButton.layer.cornerRadius = 5
        registerCompleteButton.layer.borderWidth = 1
        registerCompleteButton.layer.borderColor = UIColor.white.cgColor
        
        txtEmail.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.05)
        
        txtUserName.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.05)
        
        txtPassword.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.05)
        
        txtConfirmPassword.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.05)
    }
    
    private func clearTextField() {
        self.txtUserName.text = ""
        self.txtPassword.text = ""
        self.txtUserName.becomeFirstResponder()
        self.txtConfirmPassword.text = ""
        self.txtEmail.text = ""
    }
    
    private func displayAlertView(title:String,message:String,buttonMessage:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonMessage, style: UIAlertActionStyle.default, handler: { action in
            
            // do something like...
            self.clearTextField()
        }))
        present(alert,animated:true,completion:nil)
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
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
    
    public func checkIfEmpty() -> Bool {
        if self.txtEmail.text != "" && self.txtConfirmPassword.text != "" && self.txtPassword.text != "" && self.txtUserName.text != "" {
            return true
        } else {
            return false
        }
        
    }
}
