//
//  Extensions.swift
//  Budget Management
//
//  Created by Intern on 22/10/2020.
//

import Foundation
import XLPagerTabStrip
import SideMenu

//MARK:- uitextfield extension
extension UITextField {
    
    func setTextFieldStyle(with color: UIColor = .lightGray, for width: CGFloat = 1.0) {
        
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = 2
    }
    
    func textFieldStyle(color: UIColor) {
        self.borderStyle = .none
        let whiteColor = color
        let border = CALayer()
        let width = CGFloat(1.0)
        
        border.borderColor = whiteColor.cgColor
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: bounds.size.height - width, width: bounds.size.width, height: bounds.size.height)
        
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}


//MARK:- imageview extension for rounded image

extension UIImageView {
    func makeRoundedImage(){
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}

extension UIView {
    
    func makeRoundedView(){
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "BackgroundGrayColor")?.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}

extension ButtonBarPagerTabStripViewController {
    
    internal func setupXLPagerStrip () {
        
        settings.style.buttonBarBackgroundColor = UIColor(named: "HeaderColor")!
        settings.style.buttonBarItemBackgroundColor = UIColor(named: "HeaderColor")!
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .white
        }
    }
}


extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-50, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        UIView.animate(withDuration: 2, delay: 1, options: .transitionCurlUp, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }


