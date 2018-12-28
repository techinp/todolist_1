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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _createbuttonFB()
        
    }
    
    //MARK: - Logic
    
    func _createbuttonFB() {
        let loginbuttonFB = FBSDKLoginButton()
        loginbuttonFB.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32 , height: 50)
        loginbuttonFB.delegate = self
        view.addSubview(loginbuttonFB)
        loginbuttonFB.readPermissions = ["email", "public_profile"]
    }
    
    func showEmailFB() {
        let accessTokenCurrent = FBSDKAccessToken.current()
        guard let accessTokenString = accessTokenCurrent?.tokenString else {return}
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
            if error != nil {
                print("Something wrong")
                }
            else {
                print("Successfullt logged in \(String(describing: result))")
                self.performSegue(withIdentifier: "afterloginFB", sender: nil)
                }
            })
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"])?.start(completionHandler: { (connection, result, error) in
            if error != nil {
                print("Failed to start graph request: \(String(describing: error))")
                return
            }
            print(result)
        })
    }
    
    //MARK: - Facebook Login Delegate
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        showEmailFB()
        
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Log Out")
    }
    
    //MARK: - Interface
    
    @IBAction func loginFBButton(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email" , "public_profile"], from: self) { (result, error) in
            if error != nil {
                print("Button Login Failed : \(String(describing: error))")
                return
            }
            self.showEmailFB()
        }
    }

}
