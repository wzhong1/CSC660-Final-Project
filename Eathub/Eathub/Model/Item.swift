//
//  Item.swift
//  Eathub
//
//  Created by Wii Zh on 10/22/22.
//

import SwiftUI

struct Item: Identifiable {
    var id: String
    var item_name: String
    var item_cost: NSNumber
    var item_details: String
    var item_image: String
    var item_ratings: String
    var item_lattitue: Double
    var item_longtitue: Double
    var isAdded: Bool = false
}
