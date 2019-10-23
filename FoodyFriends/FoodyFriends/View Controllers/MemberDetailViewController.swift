//
//  MemberDetailViewController.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

protocol MemberDetailDelegate {
    func memberWasAdded(_ name: String)
}

class MemberDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    var memberDetailDelegate: MemberDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let nameText = nameTextField.text,
            !nameText.isEmpty else { return }
        
        memberDetailDelegate?.memberWasAdded(nameText)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
