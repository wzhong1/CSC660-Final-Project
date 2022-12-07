//
//  foodDeliveryView.swift
//  Eathub
//
//  Created by Wii Zh on 10/25/22.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit

struct foodDeliveryView: View{
    @Environment(\.dismiss) var dismiss
    @State var requestLocation: CLLocationCoordinate2D
    
    var body: some View{
        VStack(spacing:25){
            MyMapView(requestLocation: $requestLocation)
            Spacer()
            Button("Back"){
                dismiss()
            }
        }
    }
}
