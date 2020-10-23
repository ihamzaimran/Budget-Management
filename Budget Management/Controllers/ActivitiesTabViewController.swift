//
//  ActivitiesTabViewController.swift
//  Budget Management
//
//  Created by Intern on 23/10/2020.
//

import UIKit

class ActivitiesTabViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem = UITabBarItem(title: "Activities", image: UIImage(named: Constants.Images.activityTab), tag: 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
