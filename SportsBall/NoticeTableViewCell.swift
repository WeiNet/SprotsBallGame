//
//  NoticeTableViewCell.swift
//  SportsBall
//
//  Created by abel jing on 16/7/4.
//  Copyright © 2016年 abel jing. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {

    @IBOutlet weak var lableContent: UILabel!
    
    @IBOutlet weak var lableTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
