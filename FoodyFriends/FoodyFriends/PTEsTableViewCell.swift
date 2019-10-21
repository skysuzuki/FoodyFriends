//
//  PlaceToEatTableViewCell.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class PTEsTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var pteLabel: UILabel!
    
    // MARK: - Properties
    var placeToEat: PlaceToEat? {
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
    
    // MARK: - Class Functions
    private func updateViews() {
        guard let placeToEat = placeToEat else { return }
        pteLabel.text = placeToEat.name
    }

}
