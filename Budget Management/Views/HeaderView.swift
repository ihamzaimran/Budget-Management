//
//  HeaderView.swift
//  Budget Management
//
//  Created by Intern on 21/10/2020.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var profileImageBTN: UIButton!
    
    var delegate: didTapProfileImage?
    
    @IBAction func headerProfileImage(_ sender: UIButton) {
        delegate?.profileImageBtnPressed()
    }
}


protocol didTapProfileImage {
    func profileImageBtnPressed()
}
