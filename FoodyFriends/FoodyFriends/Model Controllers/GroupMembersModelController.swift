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
    
    init() {
        loadFromPersistentStore()
    }
    
    func addNewMember(_ name: String) {
        let newMember = Member(name)
        groupMembers.append(newMember)
        saveToPersistentStore()
    }
    
    func deleteMember(_ member: Member) {
        guard let memberIndex = groupMembers.firstIndex(of: member) else { return }
        groupMembers.remove(at: memberIndex)
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    
    private var groupMembersURL: URL? {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let filename = "GroupMembers.plist"
        return dir.appendingPathComponent(filename)
    }
        
    private func saveToPersistentStore() {
        guard let url = groupMembersURL else { return }
        
        do {
            let encoder = PropertyListEncoder()
            let groupMembersData = try encoder.encode(groupMembers)
            try groupMembersData.write(to: url)
        } catch {
            print("Error saving places to eat data: \(error)")
        }
    }
    
    private func loadFromPersistentStore() {
        let fm = FileManager.default
        guard let url = groupMembersURL,
            fm.fileExists(atPath: url.path) else { return }
        
        do {
            let groupMembersData = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let decodedGroupMembers = try decoder.decode([Member].self, from: groupMembersData)
            groupMembers = decodedGroupMembers
        } catch {
            print("Error loading places to eat data: \(error)")
        }
    }
}
