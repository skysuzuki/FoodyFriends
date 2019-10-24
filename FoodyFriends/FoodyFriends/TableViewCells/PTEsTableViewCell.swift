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
    @IBOutlet weak var pteNameLabel: UILabel!
    @IBOutlet weak var pteAddressLabel: UILabel!
    @IBOutlet weak var pteDayLabel: UILabel!
    @IBOutlet weak var pteMonthLabel: UILabel!
    @IBOutlet weak var pteImageView: UIImageView!
   
    
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
        pteNameLabel.text = placeToEat.name
        pteAddressLabel.text = placeToEat.address
        pteImageView.image = UIImage(data: placeToEat.image)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.autoupdatingCurrent
        
        // Set the date label format first
        formatter.dateFormat = "E"
        pteDayLabel.text = formatter.string(from: placeToEat.scheduledDate)
        
        // Then set the time label format
        formatter.dateFormat = "MMM, d @ h:mm a"
        pteMonthLabel.text = formatter.string(from: placeToEat.scheduledDate)
    }

}
