//
//  MemberTableViewCell.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Properties
    var member: Member? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let member = member else { return }
        nameLabel.text = member.name
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
