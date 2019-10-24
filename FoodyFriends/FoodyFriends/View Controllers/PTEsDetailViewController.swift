//
//  PTEsDetailViewController.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import UserNotifications
import Photos

protocol PTEsUpdateDelegate {
    func placesToEatWasUpdated()
}

class PTEsDetailViewController: UIViewController, UNUserNotificationCenterDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameOfPlaceTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addPhotosButton: UIButton!
    
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

        // Do any additional setup after loading the view
        
        nameOfPlaceTextField.becomeFirstResponder()
        updateViews()
        UNUserNotificationCenter.current().delegate = self
    }
    
    private func updateViews() {
        
        if let placeToEat = placeToEat {
            self.title = placeToEat.name
            nameOfPlaceTextField.text = placeToEat.name
            addressTextField.text = placeToEat.address
            descriptionTextView.text = placeToEat.description
            imageView.image = UIImage(data: placeToEat.image)
            addPhotosButton.setTitle("Edit Photo", for: .normal)
            dateAndTimeLabelFormatter(placeToEat.scheduledDate)
        } else {
            self.title = "Add a place to eat"
        }
    }

    // MARK: - Navigation

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
    
    private func showMissingFieldsAlert() {
        var message = "Please fill in:\n"
        if let nameOfPlaceText = nameOfPlaceTextField.text,
            nameOfPlaceText.isEmpty {
            message += "Name of place\n"
        }
        if let addressText = addressTextField.text,
            addressText.isEmpty {
            message += "Address\n"
        }
        if scheduledDate == nil {
            message += "Scheduled Date"
        }
        
        let alert = UIAlertController(title: "Missing Entry!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
        
    func dateNotificationContent() {
        
        let content = UNMutableNotificationContent()
        content.title = "Time to eat!"
        DispatchQueue.main.async {
            let nameOfPlaceText = self.nameOfPlaceTextField.text!
            let addressText = self.addressTextField.text!
            let dateText = self.dateLabel.text!
            let timeText = self.timeLabel.text!
            content.body = "Scheduled meetup at \(nameOfPlaceText), \(addressText) on \(dateText) at \(timeText)."
        }

        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        // Set flags so it only cares about certain datecomponents when setting it up with the Calender.current.datecomponents
        let unitFlags: Set<Calendar.Component> = [.day, .month, .year, .hour, .minute, .calendar]
        dateComponents = Calendar.current.dateComponents(unitFlags, from: scheduledDate!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
    
    // MARK: Photo Permissions
    
    private func presentImagePickerController() {
        let imagePicker = UIImagePickerController()
        DispatchQueue.main.async {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        addPhotosButton.setTitle("Edit Photo", for: .normal)
    }
    
    
    // MARK: - IBActions
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        
        guard let pteController = pteController,
            let nameOfPlaceText = nameOfPlaceTextField.text,
            let addressText = addressTextField.text,
            let imageData = imageView.image?.pngData() else { return }
        
        if (nameOfPlaceText.isEmpty || addressText.isEmpty || scheduledDate == nil) {
            showMissingFieldsAlert()
        } else {
            if let placeToEat = placeToEat {
                
                pteController.editPlaceToEat(placeToEat, updatedName: nameOfPlaceText, updatedAddress: addressText, updatedDescription: descriptionTextView.text, updatedDate: scheduledDate!, updatedImage: imageData)
            } else {
                pteController.createPlaceToEat(nameOfPlaceText, addressText, descriptionTextView.text, scheduledDate!, imageData)
            }
            scheduleDateNotification()
            self.navigationController?.popToRootViewController(animated: true)
            pteDelegate?.placesToEatWasUpdated()
        }
    }
    
    @IBAction func addPhotoTapped(_ sender: UIButton) {
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
            
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else { NSLog("User did not authorize access to the photo library"); return }
                
                self.presentImagePickerController()
            }
             
        default:
            break
        }

    }
}

// MARK: - Delegates

extension PTEsDetailViewController: PTEsDatePickerDelegate {
    
    func scheduledDateWasChosen(_ dateChosen: Date) {
        dateAndTimeLabelFormatter(dateChosen)
    }
}
