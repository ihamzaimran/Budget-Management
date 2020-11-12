//
//  GoalTransactionsTableViewCell.swift
//  Budget Management
//
//  Created by Intern on 12/11/2020.
//

import UIKit

class GoalTransactionsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var descriptionLBL: UILabel!
    @IBOutlet weak var amountLBL: UILabel!
    @IBOutlet weak var currencyLBL: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
