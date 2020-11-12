//
//  AchievedTableViewCell.swift
//  Budget Management
//
//  Created by Intern on 12/11/2020.
//

import UIKit

class AchievedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var goalIcon: UIImageView!
    @IBOutlet weak var goalName: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var goalSaved: UILabel!
    @IBOutlet weak var goalTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
