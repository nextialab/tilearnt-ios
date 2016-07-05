//
//  KnowledgeTableViewCell.swift
//  Today I Learnt
//
//  Created by Nelson Iván González on 5/5/16.
//  Copyright © 2016 Nelson Iván González. All rights reserved.
//

import UIKit

class KnowledgeTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var published: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
