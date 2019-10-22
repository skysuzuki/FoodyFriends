//
//  PTEsDetailViewController.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

protocol PTEsUpdateDelegate {
    func placesToEatWasUpdated()
}

class PTEsDetailViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameOfPlaceTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var pteController: PlacesToEatController?
    var placeToEat: PlaceToEat?
    var pteDelegate: PTEsUpdateDelegate?
    var scheduledDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateViews()
        
    }
    
    private func updateViews() {
        
        // Used when user clicks a cell
        guard let placeToEat = placeToEat else { return }
        nameOfPlaceTextField.text = placeToEat.name
        addressTextField.text = placeToEat.address
        descriptionTextView.text = placeToEat.description
        dateAndTimeLabelFormatter(placeToEat.scheduledDate)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DatePickerSegue" {
            if let datePickerVC = segue.destination as? PTEsDatePickerViewController {
                datePickerVC.datePickerDelegate = self
            }
        }
    }

    
    // MARK: - Class Functions

    private func dateAndTimeLabelFormatter(_ dateToBeFormatted: Date) {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.autoupdatingCurrent
        
        // Set the date label format first
        formatter.dateFormat = "E, MMM d, yyyy"
        dateLabel.text = formatter.string(from: dateToBeFormatted)
        
        // Then set the time label format
        formatter.dateFormat = "h:mm a"
        timeLabel.text = formatter.string(from: dateToBeFormatted)
        
        // Make sure to set the optional date variable
        scheduledDate = dateToBeFormatted
    }
    
    
    // MARK: - IBActions
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        
        guard let pteController = pteController,
            let nameOfPlaceText = nameOfPlaceTextField.text,
            let addressText = addressTextField.text,
            !nameOfPlaceText.isEmpty,
            !addressText.isEmpty,
            let scheduledDate = scheduledDate else { return }
        
        if let placeToEat = placeToEat {
            pteController.editPlaceToEat(placeToEat, updatedName: nameOfPlaceText, updatedAddress: addressText, updatedDescription: descriptionTextView.text, updatedDate: scheduledDate, updatedImage: Data())
        } else {
            pteController.createPlaceToEat(nameOfPlaceText, addressText, descriptionTextView.text, scheduledDate, Data())
        }
                
        self.navigationController?.popToRootViewController(animated: true)
        pteDelegate?.placesToEatWasUpdated()
    }

}



extension PTEsDetailViewController: PTEsDatePickerDelegate {
    
    func scheduledDateWasChosen(_ dateChosen: Date) {
        dateAndTimeLabelFormatter(dateChosen)
    }
}
