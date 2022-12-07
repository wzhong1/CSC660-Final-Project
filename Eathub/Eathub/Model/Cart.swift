//
//  Cart.swift
//  Eathub
//
//  Created by Wii Zh on 10/22/22.
//

import SwiftUI

struct Cart: Identifiable {
    var id =  UUID().uuidString
    var item: Item
    var quantity: Int
}
