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
    private var frame = CGRect.zero
    private var fname: String?
    private var em: String?
    private var imgData: Data?
    private var userID: String?
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
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
    
   //saving data to realm
    private func saveData(){
        
        print("save data function called.")
        if let id = userID{
            self.profileData.id = id
            userDefaults.setValue(id, forKey: "UserID")
            userDefaults.synchronize()
            try! self.realm.write {
                self.realm.add(self.profileData, update: .modified)
            }
            
            if let details = self.realm.objects(ProfileModel.self).filter("id = %@", id).first {
                do {
                    try self.realm.write {
                        if let name = fname, let image = imgData, let email = em{
                            details.name = name
                            details.profileImageData = image
                            details.email = email
                            print("data saved!")
                        }
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
        }
    }
    
    
    //google sign in delegate method
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let e = error {
            print("Error = \(e.localizedDescription)")
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        //        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let email = user.profile.email
        let pic = user.profile.imageURL(withDimension: UInt(1080))
        
        fname = fullName
        em = email
        userID = userId
        
        SDWebImageManager.shared.loadImage(with: pic, options: .continueInBackground) { (receivedSize, expectedSize, pic) in
            print("OK")
        } completed: { (image, data, error, cacheType, finishes, imageURL) in
            if let e = error {
                print(e.localizedDescription)
            }
            self.imgData = data
            self.saveData()
        }
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        goToDashboardVC()
    }
    
    @IBAction func guestSignInButton(_ sender: UIButton) {
        let guestLoginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.GuestLogin) as! GuestLoginViewController
        self.navigationController?.pushViewController(guestLoginVC, animated: true)
    }
    
    @IBAction func googleSignInButton(_ sender: UIButton) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    private func goToDashboardVC(){
        let tabController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.tabBar) as! UITabBarController
        self.navigationController?.pushViewController(tabController, animated: true)
    }
}



//MARK:- extension scrollView

//scrollview and paging mehtod

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

