//
//  ActivitiesTransactionsTableViewCell.swift
//  Budget Management
//
//  Created by Intern on 01/12/2020.
//

import UIKit

class ActivitiesTransactionsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var goalNameLBL: UILabel!
    @IBOutlet weak var descLBL: UILabel!
    @IBOutlet weak var amountLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
