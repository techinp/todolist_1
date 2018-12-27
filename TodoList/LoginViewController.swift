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
        
//        createFBbutton()
        _createbuttonFB()
        
    }
    
    func _createbuttonFB() {
        let loginbuttonFB = FBSDKLoginButton()
        loginbuttonFB.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32 , height: 50)
        loginbuttonFB.delegate = self
        view.addSubview(loginbuttonFB)
        loginbuttonFB.readPermissions = ["email", "public_profile"]
    }
    
   
    @IBAction func loginFBButton(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email" , "public_profile"], from: self) { (result, error) in
            if error != nil {
                print("Button Login Failed : \(String(describing: error))")
                return
            }
            self.showEmailFB()
        }
    }
        
//        let loginFBManager = FBSDKLoginManager()
//        loginFBManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
//            if (error != nil) {
//                print("Process Error !")
//            } else if (result?.isCancelled)! {
//                print("User Cancelled")
//            } else {
//                print("Login Succeeded")
//            }
//        }
//
//        let LoginManager = FBSDKLoginManager()
//        LoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
//            if let error = error {
//                print("Failed to login: \(error.localizedDescription)")
//                return
//            }
//
//            guard let accessToken = FBSDKAccessToken.current() else {
//                print("Failed to get access token")
//                return
//            }
//
//            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
//
//            Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
//                if let error = error {
//                    print("Login error: \(error.localizedDescription)")
//                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(okayAction)
//                    self.present(alertController, animated: true, completion: nil)
//
//                    return
//                }
//            })
//        }
//  }
    
//
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        print("Processing")
//
//        if (error != nil) {
//            print("Process Error !")
//        } else if result.isCancelled {
//            print("User Cancelled")
//        } else {
//            print("Login Succeeded")
//        }
//
//        guard let accessToken = FBSDKAccessToken.current() else {
//            print("Failed to get access token")
//            return
//        }
//
//        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
//        Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, err) in
//            if let error = err {
//                print("Login error: \(error.localizedDescription)")
//                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                let OkAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                alertController.addAction(OkAction)
//                self.present(alertController, animated: true, completion: nil)
//                return
//            }
//        })
//    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
