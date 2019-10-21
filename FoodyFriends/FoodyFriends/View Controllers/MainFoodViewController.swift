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

class MainFoodViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var PTEsTableView: UITableView!
    
    var pteController = PlacesToEatController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
                addPTEsVC.placeToEat = self.pteController.placesToEat[indexPath.row]
                addPTEsVC.pteDelegate = self
            }
        default:
            return
        }
        
    }
    
}

extension MainFoodViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pteController.placesToEat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = PTEsTableView.dequeueReusableCell(withIdentifier: pteCellIndentifier, for: indexPath) as? PTEsTableViewCell else { return UITableViewCell() }
        
        let placeToEat = pteController.placesToEat[indexPath.row]
        cell.placeToEat = placeToEat
        return cell
    }
}

extension MainFoodViewController: PTEsUpdateDelegate {
    func placesToEatWasUpdated() {
        PTEsTableView.reloadData()
    }
}
