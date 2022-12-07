//
//  mapView.swift
//  Eathub
//
//  Created by Wii Zh on 10/24/22.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit

struct mapView: View{
    @State var showMap = false
    @ObservedObject var homeData: HomeViewModel
    
    
    var body: some View{
        VStack{
            if homeData.details.isEmpty {
                Spacer()
                
                ProgressView()
                
                Spacer()
            } else {
                
                ScrollView(.vertical, showsIndicators: false){
                    
                    VStack(spacing: 25){
                        
                        ForEach(homeData.details){item in
                            ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                                ItemView(item: item.item)
                                HStack {
                                    Button(action: { homeData.locIndex += 1
                                        showMap.toggle()})
                                    {
                                      Image(systemName: "map")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color.blue)
                                            .clipShape(Rectangle())
                                        Text("Track Order")
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                    }.sheet(isPresented: $showMap){
                                        foodDeliveryView(requestLocation: CLLocationCoordinate2DMake( homeData.details[homeData.locIndex-1].item.item_lattitue, homeData.details[homeData.locIndex-1].item.item_longtitue) )
                                    }
                                }
                                .padding(.trailing, 10)
                                .padding(.top, 10)
                            })
                            .frame(width: UIScreen.main.bounds.width - 30)
                        }
                    }
                    Spacer(minLength: 0)
                    
                }
            }
        }
    }
}

