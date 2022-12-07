//
//  Menu.swift
//  Eathub
//
//  Created by Wii Zh on 10/22/22.
//

import SwiftUI

struct Menu: View {
    @ObservedObject var homeData : HomeViewModel
    @State var showLoginPage = false
    var body: some View {
        VStack (spacing: 15) {
            HStack(spacing: 5) {
                Text("Welcome,")
                    .font(.body)
                    .foregroundColor(.black)
                if homeData.loggedIn == false{
                    Text("User!")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                }else{
                    Text("Minh!")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button(action: {homeData.checkBot()
                    showLoginPage.toggle()
                }){
                    Text(homeData.loggedIn ? "Log Out" : "Login")
                        .foregroundColor(.black)
                }.sheet(isPresented: $showLoginPage){
                    loginView(homeData:HomeViewModel(),randomNumber: homeData.botCheck!)
                }
                
            }
            
            Divider()
            
            NavigationLink(destination: CartView(homeData: homeData)) {
                HStack(spacing: 15) {
                    Image(systemName: "cart")
                        .font(.title)
                        .foregroundColor(.orange)
                    Text("Cart")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                }
                
            }
            NavigationLink(destination: mapView(homeData: homeData)) {
                HStack(spacing: 15) {
                    Image(systemName: "torus")
                        .font(.title)
                        .foregroundColor(.orange)
                    Text("Ordered Food")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                }
            }
                
            
            Spacer()
            
            HStack {
                Spacer()
                Text("Version 1.0")
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
        }
        .padding(10)
        .padding([.top, .trailing])
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color.white.ignoresSafeArea())
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu(homeData: HomeViewModel())
    }
}
