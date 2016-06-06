//
//  BasktballResultView1.swift
//  SportsBall
//
//  Created by Brook on 16/6/6.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class BasktballResultView: UITableViewCell {

    @IBOutlet var N_VISIT_NAME: UILabel!
    @IBOutlet var N_HOME_NAME: UILabel!
    @IBOutlet var N_GAMEDATE: UILabel!
    @IBOutlet var N_UP_VISIT_RESULT: UILabel!
    @IBOutlet var N_UP_HOME_RESULT: UILabel!
    @IBOutlet var N_DO_VISIT_RESULT: UILabel!
    @IBOutlet var N_DO_HOME_RESULT: UILabel!
    @IBOutlet var N_VISIT_RESULT: UILabel!
    @IBOutlet var N_HOME_RESULT: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
