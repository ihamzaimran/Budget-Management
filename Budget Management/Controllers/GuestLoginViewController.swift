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
        let dashbaordVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.StoryboardIDs.dashboard) as! DashBoard
        self.navigationController?.pushViewController(dashbaordVC, animated: true)
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
