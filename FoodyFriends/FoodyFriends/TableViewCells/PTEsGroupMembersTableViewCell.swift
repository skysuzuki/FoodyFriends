//
//  PTEsGroupMembersTableViewCell.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class PTEsGroupMembersTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isComingLabel: UILabel!
    
    var member: Member? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateViews() {
        guard let member = member else { return }
        nameLabel.text = member.name
        if(member.isGoing) {
            isComingLabel.text = "Attending"
            isComingLabel.textColor = .green
        } else {
            isComingLabel.text = "Not Attending"
            isComingLabel.textColor = .red
        }        
    }
}
