//
//  SavingsTableViewCell.swift
//  Budget Management
//
//  Created by Intern on 09/11/2020.
//

import UIKit

class SavingsTableViewCell: UITableViewCell {

    @IBOutlet weak var savingsView: UIView!
    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var goalIcon: UIImageView!
    @IBOutlet weak var goalProgress: UIProgressView!
    @IBOutlet weak var goalSaved: UILabel!
    @IBOutlet weak var totalGoal: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
