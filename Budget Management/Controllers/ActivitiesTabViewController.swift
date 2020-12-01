//
//  ActivitiesTabViewController.swift
//  Budget Management
//
//  Created by Intern on 23/10/2020.
//

import UIKit
import XLPagerTabStrip

class ActivitiesTabViewController: ButtonBarPagerTabStripViewController {
    
    private var date = [String]()
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem = UITabBarItem(title: "Activities", image: UIImage(named: Constants.Images.activityTab), tag: 2)
    }
    
    override func viewDidLoad() {
        
        setupXLPagerStrip()
        super.viewDidLoad()
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let dateFormatter = DateFormatter()
        let today = Date()
        let currentCalendar = Calendar.current
        let yearComponents: DateComponents? = currentCalendar.dateComponents([.year], from: today)
        let currentYear = Int(yearComponents!.year!)
        
        var childs = [UIViewController]()
        for months in 0..<12 {
            let d = "\(dateFormatter.shortMonthSymbols[months]) \(currentYear)"
            let child1 = UIStoryboard(name: Constants.StoryboardName.secondStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardIDs.allActivityStoryboard) as! AllActivityViewController
            child1.childNumber = d
            childs.append(child1)
        }
        
        return childs
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let curMonth = "May 2020"
        if curMonth == "Apr 2020" {
            moveToViewController(at: 3, animated: true)
        } else {
            moveToViewController(at: 11, animated: true)
        }
    }
}
