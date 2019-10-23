//
//  GroupMembersModelController.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class GroupMembersModelController {
    
    var groupMembers = [Member]()
    
    func addNewMember(_ name: String) {
        let newMember = Member(name)
        groupMembers.append(newMember)
    }
    
    func deleteMember(_ member: Member) {
        guard let memberIndex = groupMembers.firstIndex(of: member) else { return }
        groupMembers.remove(at: memberIndex)
    }
    
    
}
