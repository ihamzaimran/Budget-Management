//
//  LoginViewController.swift
//  Budget Management
//
//  Created by Intern on 27/10/2020.
//

import UIKit
import GoogleSignIn
import RealmSwift
import SDWebImage

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var loginCollectionView: UICollectionView!
    
    private let profileData = ProfileModel()
    private let realm = try! Realm()
    private let images = Constants.Images.loginPager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        loginCollectionView.delegate = self
        loginCollectionView.dataSource = self
        loginCollectionView.backgroundColor = nil
    }
    
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
        //        let userId = user.userID                  // For client-side use only!
        //        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        //        let givenName = user.profile.givenName
        //        let familyName = user.profile.familyName
        let email = user.profile.email
        let pic = user.profile.imageURL(withDimension: UInt(1080))
        
        
        SDWebImageManager.shared.loadImage(with: pic, options: .continueInBackground) { (receivedSize, expectedSize, pic) in
            print("OK")
        } completed: { (image, data, error, cacheType, finishes, imageURL) in
            if let e = error {
                print(e.localizedDescription)
            }
            
            if let email = email{
                self.profileData.email = email
                
                try! self.realm.write {
                    self.realm.add(self.profileData)
                }
                
                if let details = self.realm.objects(ProfileModel.self).filter("email = %@", email).first {
                    do {
                        try self.realm.write {
                            let profileDetails = ProfileDetails()
                            if let name = fullName, let image = data {
                                profileDetails.name = name
                                profileDetails.profileImageData = image
                                details.details.append(profileDetails)
                            }
                        }
                    } catch {
                        print("Error saving new items, \(error)")
                    }
                }
            }
        }
    }
    
    
    @IBAction func signInGuestButton(_ sender: UIButton) {
        //        print("name = \(profileData.name)")
        print("email = \(profileData.email)")
        //        print("data = \(profileData.profileImageURL)")
    }
    
    @IBAction func signInGoogleButton(_ sender: UIButton) {
        // If user already sign in, restore sign-in state.
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func backIcon(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension LoginViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.TableViewIdentifier.loginCollectionCellIdentifier, for: indexPath) as! LoginCollectionViewCell
        cell.backgroundColor = nil
        cell.loginCollectionViewImage.image = UIImage(named: images[indexPath.row])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 0
        let collectionCellSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionCellSize, height: collectionCellSize)
    }
    
}
    
