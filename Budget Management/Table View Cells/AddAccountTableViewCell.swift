//
//  AddAccountTableViewCell.swift
//  Budget Management
//
//  Created by Intern on 19/11/2020.
//

import UIKit

class AddAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var balanceLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
