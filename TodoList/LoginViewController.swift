//
//  LoginViewController.swift
//  TodoList
//
//  Created by Techin Pawantao on 12/21/18.
//  Copyright © 2018 Techin Pawantao. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var btn_Facebook: UIButton!
    
    private var fbLoginSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loginWithFacebook()
        
        setup_btn_Facebook()
        btn_Facebook.addTarget(self, action: #selector(HoldDown), for: .touchDown)
        btn_Facebook.addTarget(self, action: #selector(HoldRelease), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let token = AccessToken.current
//        if  token == nil {
//            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
//        }
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
    
//    func loginWithFacebook() {
//        //Check for previous Access Token
//        if let accessToken = AccessToken.current {
//            //AccessToken was obtained during same session
//            getAccountDetails(withAccessToken: accessToken)
//        }
//        else if let strAuthenticationToken = UserDefaults.standard.string(forKey: "AccessToken_Facebook") {
//            //A previous access token string was saved so create the required AccessToken object
//            let accessToken = AccessToken(authenticationToken: strAuthenticationToken)
//
//            //Skip Login and directly proceed to get facebook profile data with an AccessToken
//            getAccountDetails(withAccessToken: accessToken)
//            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
//
//        }
//        else {
//            //Access Token was not available so do the normal login flow to obtain the Access Token
//            handleSignInFacebookWhenTapped()
//        }
//    }
    
    @objc func handleSignInFacebookWhenTapped() {
        
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile , .email], viewController: nil) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print("Successfully Logged in into Facebook...")
//                let accessToken  = AccessToken.current
//                //Save Access Token string for silent login purpose later
//                let strAuthenticationToken = AccessToken.current?.authenticationToken
//                UserDefaults.standard.set(strAuthenticationToken,
//                                          forKey: "AccessToken_Facebook")
//
//                //Proceed to get facebook profile data
//                self.getAccountDetails(withAccessToken: accessToken!)
                self.signInToFirebase()
            case .failed(let err):
                print(err)
            case .cancelled:
                print("Cancelled")
             }
        }
    }
    
//    func getAccountDetails(withAccessToken accessToken: AccessToken) {
//        let graphRequest: GraphRequest = GraphRequest(graphPath     : "me",
//                                                      parameters    : ["fields" : "id, name, email"],
//                                                      accessToken   : accessToken,
//                                                      httpMethod    : GraphRequestHTTPMethod.GET,
//                                                      apiVersion    : GraphAPIVersion.defaultVersion)
//        graphRequest.start { (response, result) in
//            switch result {
//            case .success(let resultResponse):
//                print(resultResponse)
//                print("0000000000000000000000000000000000000000000000000")
//            case .failed(let error):
//                print(error)
//                print("111111111111111111111111111111111111111111111111")
//            }
//        }
//    }
    
    fileprivate func signInToFirebase() {
        let authenticationToken = AccessToken.current?.authenticationToken
        let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken!)
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            if let err = error {
                print(err)
                return
            } else {
                print("Successfully Logged in into Firebase...")
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
        }
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
