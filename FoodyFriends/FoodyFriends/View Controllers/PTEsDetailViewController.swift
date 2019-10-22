//
//  PTEsDetailViewController.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import UserNotifications

protocol PTEsUpdateDelegate {
    func placesToEatWasUpdated()
}

class PTEsDetailViewController: UIViewController, UNUserNotificationCenterDelegate {

    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameOfPlaceTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Properties
    // Set
    let notificationCenter = UNUserNotificationCenter.current()
    
    // Optionals
    var pteController: PlacesToEatController?
    var placeToEat: PlaceToEat?
    var pteDelegate: PTEsUpdateDelegate?
    var scheduledDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateViews()
        UNUserNotificationCenter.current().delegate = self
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
                datePickerVC.scheduledDate = self.scheduledDate
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
    
    // MARK: Notification functions
    private func scheduleDateNotification() {
        notificationCenter.getNotificationSettings { settings in
            
            switch settings.authorizationStatus {
            case .authorized:
                self.dateNotificationContent()
                
            case .notDetermined:
                self.notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                    
                    guard granted else { return }
                    
                    self.dateNotificationContent()
                }
            default:
                break
            }
        }
        
    }
        
    private func dateNotificationContent() {
        
        let content = UNMutableNotificationContent()
        content.title = "Time to eat!"
        content.body = "Scheduled meetup at \(nameOfPlaceTextField.text!), \(addressTextField.text!) on \(dateLabel.text!) at \(timeLabel.text!)."
        //content.categoryIdentifier = "alarm"
        //content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        
        var dateComponents = DateComponents()
        // Set flags so it only cares about certain datecomponents when setting it up with the Calender.current.datecomponents
        let unitFlags: Set<Calendar.Component> = [.day, .month, .year, .hour, .minute, .calendar]
        dateComponents = Calendar.current.dateComponents(unitFlags, from: scheduledDate!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.add(request)
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
        
        scheduleDateNotification()
        self.navigationController?.popToRootViewController(animated: true)
        pteDelegate?.placesToEatWasUpdated()
    }

}

// MARK: - Delegates

extension PTEsDetailViewController: PTEsDatePickerDelegate {
    
    func scheduledDateWasChosen(_ dateChosen: Date) {
        dateAndTimeLabelFormatter(dateChosen)
    }
}
