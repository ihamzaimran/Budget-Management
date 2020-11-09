//
//  SceneDelegate.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        GIDSignIn.sharedInstance()?.delegate = self
        isUserLoggedIn()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}


extension SceneDelegate: GIDSignInDelegate{
    
    private func isUserLoggedIn(){
        
        let userDefaults = UserDefaults.standard
        
        if let _ = userDefaults.string(forKey: "UserID") {
            print(userDefaults.string(forKey: "UserID"))
            print("Logging in...")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ivc = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIDs.tabBar) as? UITabBarController
            var navigationController: UINavigationController? = nil
            if let ivc = ivc {
                navigationController = UINavigationController(rootViewController: ivc)
                navigationController?.navigationBar.isHidden = true
                navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
            }
            window?.rootViewController = nil
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        } else {
            print("Current user not found, Need to sign in.")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ivc = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIDs.login) as? LoginPageViewController
            var navigationController: UINavigationController? = nil
            if let ivc = ivc {
                navigationController = UINavigationController(rootViewController: ivc)
                navigationController?.navigationBar.isHidden = true
                navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
            }
            window?.rootViewController = nil
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
    }
}
