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

extension ButtonBarPagerTabStripViewController {
    
    func setUpPagaingView() {
        
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


