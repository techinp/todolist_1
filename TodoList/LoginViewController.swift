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

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createFBbutton()
        
    }
   
    @IBAction func loginFBButton(_ sender: Any) {
        
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
