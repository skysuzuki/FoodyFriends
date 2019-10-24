//
//  ViewController.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

private let pteCellIndentifier = "PTEsCell"
private let pteAddSegueIdentifier = "PTEsAddSegue"
private let pteDetailSegueIdentifier = "PTEsDetailSegue"
private let groupMembersSegueIdentifier = "GroupMembersSegue"

class MainFoodViewController: UIViewController, UNUserNotificationCenterDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var PTEsTableView: UITableView!
    
    var pteController = PlacesToEatController()
    var groupMembersController = GroupMembersModelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UNUserNotificationCenter.current().delegate = self
    }
    
    private func placeToEatFor(indexPath: IndexPath) -> PlaceToEat {
        if(indexPath.section == 0) {
            return pteController.scheduledPlacesToEat[indexPath.row]
        } else {
            return pteController.pastDatePlacesToEat[indexPath.row]
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case pteAddSegueIdentifier:
            if let addPTEsVC = segue.destination as? PTEsDetailViewController {
                addPTEsVC.pteController = self.pteController
                addPTEsVC.pteDelegate = self
            }
        case pteDetailSegueIdentifier:
            guard let indexPath = PTEsTableView.indexPathForSelectedRow else { return }
            if let addPTEsVC = segue.destination as? PTEsDetailViewController {
                addPTEsVC.pteController = self.pteController
                addPTEsVC.groupMembersController = self.groupMembersController
                addPTEsVC.placeToEat = placeToEatFor(indexPath: indexPath)
                addPTEsVC.pteDelegate = self
            }
        case groupMembersSegueIdentifier:
            if let groupMembersVC = segue.destination as? GroupMembersTableViewController {
                groupMembersVC.groupMembersController = self.groupMembersController
            }
        default:
            return
        }
        
    }
    
}

extension MainFoodViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return pteController.scheduledPlacesToEat.count
        } else if (section == 1) {
            return pteController.pastDatePlacesToEat.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Scheduled"
        case 1:
            return "Expired"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = PTEsTableView.dequeueReusableCell(withIdentifier: pteCellIndentifier, for: indexPath) as? PTEsTableViewCell else { return UITableViewCell() }
        
        let placeToEat = placeToEatFor(indexPath: indexPath)
        cell.placeToEat = placeToEat
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let placeToEat = placeToEatFor(indexPath: indexPath)
            pteController.deletePlaceToEat(placeToEat)
            PTEsTableView.deleteRows(at: [indexPath], with: .fade)
        }
        PTEsTableView.reloadData()
    }
}

extension MainFoodViewController: PTEsUpdateDelegate {
    func placesToEatWasUpdated() {
        pteController.sortPlaceToEatByDate()
        PTEsTableView.reloadData()
    }
}
