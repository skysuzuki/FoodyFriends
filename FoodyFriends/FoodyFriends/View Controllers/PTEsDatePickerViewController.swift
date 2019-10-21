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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
