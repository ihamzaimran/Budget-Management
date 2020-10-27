//
//  LoginViewController.swift
//  Budget Management
//
//  Created by Intern on 27/10/2020.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        
        let dimension = round(100 * UIScreen.main.scale)
        let pic = user.profile.imageURL(withDimension: UInt(dimension))
        
        print("ImageURL: \(pic)")
        print("Email: \(email) \n Name: \(fullName)")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    @IBAction func signInGuestButton(_ sender: UIButton) {
        
    }
    
    @IBAction func signInGoogleButton(_ sender: UIButton) {
        // If user already sign in, restore sign-in state.
        GIDSignIn.sharedInstance()?.signIn()
    }
    
}
