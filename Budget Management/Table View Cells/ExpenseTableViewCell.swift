//
//  ExpenseTableViewCell.swift
//  Budget Management
//
//  Created by Intern on 26/11/2020.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    @IBOutlet weak var expenseImageView: UIImageView!
    @IBOutlet weak var expenseLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
