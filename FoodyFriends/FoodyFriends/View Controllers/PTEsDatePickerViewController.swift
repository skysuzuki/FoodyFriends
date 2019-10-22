//
//  PTEsDatePickerViewController.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

protocol PTEsDatePickerDelegate {
    func scheduledDateWasChosen(_ dateChosen: Date)
}

class PTEsDatePickerViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    // MARK: - Properties
    var datePickerDelegate: PTEsDatePickerDelegate?
    var scheduledDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateViews()
    }
    
    private func updateViews() {
        
        // Makes sure user cannot set a date to anything before current date
        let currentDate = Date()
        datePicker.minimumDate = currentDate
        // If date passed in is not optional set it to the current date/time
        if let scheduledDate = scheduledDate {
            datePicker.setDate(scheduledDate, animated: false)
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        datePickerDelegate?.scheduledDateWasChosen(datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
