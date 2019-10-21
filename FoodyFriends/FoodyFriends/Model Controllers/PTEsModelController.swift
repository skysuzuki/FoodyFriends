//
//  PTEsModelController.swift
//  FoodyFriends
//
//  Created by Lambda_School_Loaner_204 on 10/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class PlacesToEatController  {
    
    var placesToEat = [PlaceToEat]()
    
    
    
    // MARK: - Class Functions
    func createPlaceToEat(_ name: String, _ address: String, _ description: String,
                          _ scheduledDate: Date, _ imageData: Data) {
        let placeToEat = PlaceToEat(name: name, address: address, description: description, scheduledDate: scheduledDate, image: imageData)
        placesToEat.append(placeToEat)
    }
    
    func editPlaceToEat(_ placeToEat: PlaceToEat,
                        updatedName name: String,
                        updatedAddress address: String,
                        updatedDescription description: String,
                        updatedDate scheduledDate: Date,
                        updatedImage imageData: Data) {
        if let pteIndex = placesToEat.firstIndex(of: placeToEat) {
            placesToEat[pteIndex].name = name
            placesToEat[pteIndex].address = address
            placesToEat[pteIndex].description = description
            placesToEat[pteIndex].scheduledDate = scheduledDate
            placesToEat[pteIndex].image = imageData
        }
    }
}
