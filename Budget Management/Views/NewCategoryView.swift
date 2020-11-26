//
//  NewCategoryView.swift
//  Budget Management
//
//  Created by Intern on 26/11/2020.
//

import UIKit

class NewCategoryView: UIView, UITextFieldDelegate {
    @IBOutlet weak var categoryTitleLBL: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var cancelBTN: UIButton!
    @IBOutlet weak var saveBTN: UIButton!
    @IBOutlet weak var selectIconBtn: UIButton!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var selectIconView: UIView!
    @IBOutlet weak var categoryView: UIView!
    
    //MARK:- new category alert textfield delegate extension
    
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        
//        if titleTxtField.isFirstResponder {
//            titleTxtField.resignFirstResponder()
//        }
//        return false
//    }
}
