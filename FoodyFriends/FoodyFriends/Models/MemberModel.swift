//
//  MemberModel.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Member: Equatable, Codable {
    var name: String
    var isGoing: Bool
    
    init(_ name: String, _ isGoing: Bool = false) {
        self.name = name
        self.isGoing = isGoing
    }
}
