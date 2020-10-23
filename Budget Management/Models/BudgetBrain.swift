//
//  OpenExternalLinks.swift
//  Budget Management
//
//  Created by Intern on 23/10/2020.
//

import Foundation

struct BudgetBrain {
    
    internal func openExternalLink(with urlString: String){
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, completionHandler: nil)
        } else {
            print("Error occured! Couldn't open link.")
            return
        }
    }
}
