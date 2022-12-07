//
//  loginView.swift
//  Eathub
//
//  Created by Wii Zh on 11/1/22.
//

import Foundation
import SwiftUI

struct loginView : View{
    @StateObject var homeData : HomeViewModel
    
    @State var username: String = ""
    @State var password: String = ""
    @State var randomNumber: Int
    @State var numberEnteredByUser: String = ""
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View{
        VStack{
            Text("Welcome")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom)
            TextField("Username", text: $username)
                .padding()
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            SecureField("Password", text: $password)
                .padding()
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            TextField("Please enter the number is shown below", text: $numberEnteredByUser)
                .padding()
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Label {
                Text("\(randomNumber)")
                    .foregroundColor(Color.red)
            } icon: {
                Image(systemName: "keyboard")
                    .foregroundColor(Color.blue)
            }
            .padding()
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            Button(action: {
                if(Int(numberEnteredByUser) == randomNumber){
                    homeData.login()
                    self.mode.wrappedValue.dismiss()
                }else{
                    print("Something went wrong")
                }
            }){
                Text("LOGIN")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }
            
            Button("Back"){
                dismiss()
            }
        }
        .padding()
    }
    
}
