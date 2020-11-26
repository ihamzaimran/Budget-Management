//
//  IncomeTableViewCell.swift
//  Budget Management
//
//  Created by Intern on 26/11/2020.
//

import UIKit

class IncomeTableViewCell: UITableViewCell {

    @IBOutlet weak var incomeLBL: UILabel!
    @IBOutlet weak var incomeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
