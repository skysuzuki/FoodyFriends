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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateViews()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func updateViews() {
        
        guard let placeToEat = placeToEat else { return }
        nameOfPlaceTextField.text = placeToEat.name
        addressTextField.text = placeToEat.address
        descriptionTextView.text = placeToEat.description
    }
    
    // MARK: - IBActions
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        
        guard let pteController = pteController,
            let nameOfPlaceText = nameOfPlaceTextField.text,
            let addressText = addressTextField.text,
            !nameOfPlaceText.isEmpty,
            !addressText.isEmpty else { return }
        
        if let placeToEat = placeToEat {
            pteController.editPlaceToEat(placeToEat, updatedName: nameOfPlaceText, updatedAddress: addressText, updatedDescription: descriptionTextView.text, updatedDate: Date(), updatedImage: Data())
        } else {
            pteController.createPlaceToEat(nameOfPlaceText, addressText, descriptionTextView.text, Date(), Data())
        }
                
        self.navigationController?.popToRootViewController(animated: true)
        pteDelegate?.placesToEatWasUpdated()
    }

}
