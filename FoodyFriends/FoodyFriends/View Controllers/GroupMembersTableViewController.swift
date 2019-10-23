//
//  GroupMembersTableViewController.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

private let memberCellIdentifier = "MemberCell"

class GroupMembersTableViewController: UITableViewController {
    
    var groupMembersController: GroupMembersModelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let groupMembersController = groupMembersController else { return 0 }
        return groupMembersController.groupMembers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: memberCellIdentifier, for: indexPath) as? MemberTableViewCell else { return UITableViewCell() }

        // Configure the cell...
        let member = groupMembersController?.groupMembers[indexPath.row]
        cell.member = member
        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            guard let groupMembersController = groupMembersController else { return }
            let member = groupMembersController.groupMembers[indexPath.row]
            groupMembersController.deleteMember(member)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddMemberSegue" {
            if let memberDetailVC = segue.destination as? MemberDetailViewController {
                memberDetailVC.memberDetailDelegate = self
            }
        }
    }
}

extension GroupMembersTableViewController: MemberDetailDelegate {
    func memberWasAdded(_ name: String) {
        groupMembersController?.addNewMember(name)
        tableView.reloadData()
    }
}
