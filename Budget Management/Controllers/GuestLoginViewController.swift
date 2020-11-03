//
//  GuestLoginViewController.swift
//  Budget Management
//
//  Created by Intern on 02/11/2020.
//

import UIKit

class GuestLoginViewController: UIViewController {
    
    @IBOutlet weak var userTypeView: UIView!
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var studentImageView: UIImageView!
    @IBOutlet weak var professionalImageView: UIImageView!
    @IBOutlet weak var housewifeImageView: UIImageView!
    @IBOutlet weak var retiredImageView: UIImageView!
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTypeView.addShadow()
        currencyView.addShadow()
    }
    
    @IBAction func backIconButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectCurrencyButton(_ sender: UIButton) {
        
    }
    
    @IBAction func getStartedButton(_ sender: UIButton) {
        
        let checkSelected = checkUserTypeSelected()
        if checkSelected == true {
            print("User selected")
            let dashbaordVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.dashboard) as! DashBoard
            self.navigationController?.pushViewController(dashbaordVC, animated: true)
        } else {
            print("User type not selected")
        }
    }
    
    @IBAction func studentImageViewTapped(_ sender: UITapGestureRecognizer) {
        studentImageView.image = UIImage(named: "student_selected")
        
        housewifeImageView.image = UIImage(named: "icon_housewife")
        professionalImageView.image = UIImage(named: "icon_professional")
        retiredImageView.image = UIImage(named: "icon_retired")
        
        studentImageView.tag = 11
        housewifeImageView.tag = 3
        professionalImageView.tag = 2
        retiredImageView.tag = 4
    }
    
    @IBAction func professionalImageViewTapped(_ sender: UITapGestureRecognizer) {
        professionalImageView.image = UIImage(named: "prof_selected")
        
        studentImageView.image = UIImage(named: "icon_student")
        housewifeImageView.image = UIImage(named: "icon_housewife")
        retiredImageView.image = UIImage(named: "icon_retired")
        
        studentImageView.tag = 1
        housewifeImageView.tag = 3
        professionalImageView.tag = 22
        retiredImageView.tag = 4
    }
    
    @IBAction func housewifeImageViewTapped(_ sender: UITapGestureRecognizer) {
        housewifeImageView.image = UIImage(named: "house_selected")
        
        studentImageView.image = UIImage(named: "icon_student")
        professionalImageView.image = UIImage(named: "icon_professional")
        retiredImageView.image = UIImage(named: "icon_retired")
        
        studentImageView.tag = 1
        housewifeImageView.tag = 33
        professionalImageView.tag = 2
        retiredImageView.tag = 4
    }
    
    @IBAction func retiredImageViewTapped(_ sender: UITapGestureRecognizer) {
        retiredImageView.image = UIImage(named: "retired_selected")
        
        studentImageView.image = UIImage(named: "icon_student")
        professionalImageView.image = UIImage(named: "icon_professional")
        housewifeImageView.image = UIImage(named: "icon_housewife")
        
        studentImageView.tag = 1
        housewifeImageView.tag = 3
        professionalImageView.tag = 2
        retiredImageView.tag = 44
    }
    
    private func checkUserTypeSelected()->Bool{
        if studentImageView.tag == 1 && housewifeImageView.tag == 3 && professionalImageView.tag == 2 && retiredImageView.tag == 4 {
            return false
        } else {
            return true
        }
    }
    
}
//MARK:- guest login uiview shadow

extension UIView {
    func addShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
