//
//  PTEsModel.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct PlaceToEat: Equatable, Codable {
    var name: String
    var address: String
    var description: String
    var scheduledDate: Date
    var image: Data
}
