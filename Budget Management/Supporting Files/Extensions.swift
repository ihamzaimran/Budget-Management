//
//  Extensions.swift
//  Budget Management
//
//  Created by Intern on 22/10/2020.
//

import Foundation

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
