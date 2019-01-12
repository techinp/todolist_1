//
//  LoginViewController.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/21/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate{
    
    @IBOutlet weak var btn_Facebook: UIButton!
    
    private var fbLoginSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup_btn_Facebook()
        btn_Facebook.addTarget(self, action: #selector(HoldDown), for: .touchDown)
        btn_Facebook.addTarget(self, action: #selector(HoldRelease), for: .touchUpInside)
    }
    
    //MARK: - Logic
    
    @objc func HoldDown() {
        let red = hexStringToUIColor(hex: "#e74c3c")
        btn_Facebook.layer.borderColor = red.cgColor
        btn_Facebook.layer.borderWidth = 2
        btn_Facebook.tintColor = red

    }
    
    @objc func HoldRelease() {
        btn_Facebook.layer.borderColor = UIColor.white.cgColor
        btn_Facebook.layer.borderWidth = 2
        btn_Facebook.tintColor = UIColor.white
    }
    
    
    func setup_btn_Facebook() {
        
        let logoFacebook: UIImageView = {
            let iv = UIImageView()
            
            // Set image with image literal
            iv.image = #imageLiteral(resourceName: "Facebook")
            return iv
        }()
        
        btn_Facebook.layer.borderColor = UIColor.white.cgColor
        btn_Facebook.layer.borderWidth = 2
        btn_Facebook.layer.cornerRadius = 30
        btn_Facebook.backgroundColor = UIColor.clear
        btn_Facebook.contentEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        btn_Facebook.setImage(logoFacebook.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn_Facebook.tintColor = UIColor.white
        btn_Facebook.contentMode = .left
        btn_Facebook.addTarget(self, action: #selector(handleSignInFacebookWhenTapped), for: .touchUpInside)
        
    }
    
    @objc func handleSignInFacebookWhenTapped() {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile" , "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to Login : \(error.localizedDescription)")
            } else if (result?.isCancelled)! {
                print("Facebook login was cancelled.")
            } else {
                guard let accessToken = FBSDKAccessToken.current() else {
                    print("Failed to get access Token")
                    return
                }
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
                    if error != nil {
                        print("Login error: \(error!.localizedDescription)")
                    } else {
                        self.fbLoginSuccess = true
                        print("Loged in")
                        self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                    }
                })
            }
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Log Out")
    }
    
    //MARK: - Interface
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
