//
//  LoginPageViewController.swift
//  Budget Management
//
//  Created by Intern on 02/11/2020.
//

import UIKit
import GoogleSignIn
import SDWebImage
import RealmSwift

class LoginPageViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var loginPageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var slides:[LoginPageView] = []
    private let profileData = ProfileModel()
    private let realm = try! Realm()
    private let images = Constants.Images.loginPager
    var frame = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        if GIDSignIn.sharedInstance()?.currentUser != nil
        {
            print("User already signed in.")
            goToDashboardVC()
        }
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        loginScrollView.delegate = self
                slides = createSlides()
                setupSlideScrollView(slides: slides)
        
        self.loginScrollView.contentSize.height = 1.0
        loginPageControl.numberOfPages = slides.count
        loginPageControl.currentPage = 0
        view.bringSubviewToFront(loginPageControl)
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let e = error {
            print("Error = \(e.localizedDescription)")
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            return
        }
        // Perform any operations on signed in user here.
        //        let userId = user.userID                  // For client-side use only!
        //        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
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
                                print("data saved!")
                            }
                        }
                    } catch {
                        print("Error saving new items, \(error)")
                    }
                }
            }
        }
        self.activityIndicator.stopAnimating()
        goToDashboardVC()
    }
    
    @IBAction func guestSignInButton(_ sender: UIButton) {
        let guestLoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.GuestLogin) as! GuestLoginViewController
        self.navigationController?.pushViewController(guestLoginVC, animated: true)
    }
    
    @IBAction func googleSignInButton(_ sender: UIButton) {
        
        if GIDSignIn.sharedInstance()?.currentUser != nil
        {
            print("User already signed in.")
            goToDashboardVC()
            
        } else {
            print("User not Signed in.")
            activityIndicator.isHidden = false
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
    
    private func goToDashboardVC(){
        let dashboardVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.dashboard) as! DashBoard
        self.navigationController?.pushViewController(dashboardVC, animated: true)
    }
}



//MARK:- extension scrollView

extension LoginPageViewController: UIScrollViewDelegate {
    
    func createSlides() -> [LoginPageView] {
        let slide1: LoginPageView = Bundle.main.loadNibNamed("LoginPageView", owner: self, options: nil)?.first as! LoginPageView
        slide1.loginPageViewImage.image = UIImage(named: "into_image_1")

        let slide2: LoginPageView = Bundle.main.loadNibNamed("LoginPageView", owner: self, options: nil)?.first as! LoginPageView
        slide2.loginPageViewImage.image = UIImage(named: "into_image_2")

        let slide3: LoginPageView = Bundle.main.loadNibNamed("LoginPageView", owner: self, options: nil)?.first as! LoginPageView
        slide3.loginPageViewImage.image = UIImage(named: "into_image_3")

        let slide4: LoginPageView = Bundle.main.loadNibNamed("LoginPageView", owner: self, options: nil)?.first as! LoginPageView
        slide4.loginPageViewImage.image = UIImage(named: "into_image_4")

        return [slide1, slide2, slide3, slide4]
    }

    func setupSlideScrollView(slides : [LoginPageView]) {
        loginScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        loginScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        loginScrollView.isPagingEnabled = true

        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            loginScrollView.addSubview(slides[i])
        }
    }

    /*
     * default function called when view is scolled. In order to enable callback
     * when scrollview is scrolled, the below code needs to be called:
     * slideScrollView.delegate = self or
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        loginPageControl.currentPage = Int(pageIndex)

        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x

        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y

        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset


        /*
         * below code scales the imageview on paging the scrollview
         */
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)

        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {

            slides[0].loginPageViewImage.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            slides[1].loginPageViewImage.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)

        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            slides[1].loginPageViewImage.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
            slides[2].loginPageViewImage.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)

        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            slides[2].loginPageViewImage.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            slides[3].loginPageViewImage.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
        }
    }

}


//MARK:- Google signin extension

extension LoginPageViewController {
    
    
    
}
