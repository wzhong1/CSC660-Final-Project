//
//  HomeViewModel.swift
//  Eathub
//
//  Created by Wii Zh on 10/22/22.
//
import UIKit
import SwiftUI
import CoreLocation
import Firebase

// Fetching user location
class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    
    // Location
    @Published var userLocation : CLLocation!
    @Published var userAddress = ""
    @Published var hasLocation = true;
    
    // Menu
    @Published var showMenu = false;
    
    //User
    @Published var loggedIn : Bool = false
    @Published var botCheck : Int?
    @Published var botVerified : Bool = false
    
    // Item
    @Published var items: [Item] = [Item(id: "001", item_name: "Chicken Salad", item_cost: 15, item_details: "Healthy salad plate with quinoa, tomatoes, chicken, avocado, lime and mixed greens (lettuce, parsley) on wooden background top view. Food and health. Nutritious meal.", item_image: "https://www.eatwell101.com/wp-content/uploads/2019/04/Blackened-Chicken-and-Avocado-Salad-recipe-1.jpg", item_ratings: "3", item_lattitue: 37.753408464602074, item_longtitue: -122.40688666773566),Item(id: "002", item_name: "Grilled Steak", item_cost: 24, item_details: "Sliced medium rare grilled steak with spices on wooden board.", item_image: "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F19%2F2005%2F06%2F13%2Fmr20reshoot20sirloin-2000.jpg&q=60", item_ratings: "4", item_lattitue: 37.75096538135834, item_longtitue: -122.39499911798262),Item(id: "003", item_name: "Italian Sausage", item_cost: 8, item_details: "Italian sausages with fennel seeds", item_image: "https://www.sipandfeast.com/wp-content/uploads/2021/10/Italian-sausage-potatoes-recipe-snippet.jpg", item_ratings: "5", item_lattitue: 37.777358920314185, item_longtitue: -122.42619924422566)]
    @Published var filteredItems: [Item] = [Item(id: "001", item_name: "Chicken Salad", item_cost: 15, item_details: "Healthy salad plate with quinoa, tomatoes, chicken, avocado, lime and mixed greens (lettuce, parsley) on wooden background top view. Food and health. Nutritious meal.", item_image: "https://www.eatwell101.com/wp-content/uploads/2019/04/Blackened-Chicken-and-Avocado-Salad-recipe-1.jpg", item_ratings: "3", item_lattitue: 37.753408464602074, item_longtitue: -122.40688666773566),Item(id: "002", item_name: "Grilled Steak", item_cost: 24, item_details: "Sliced medium rare grilled steak with spices on wooden board.", item_image: "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F19%2F2005%2F06%2F13%2Fmr20reshoot20sirloin-2000.jpg&q=60", item_ratings: "4", item_lattitue: 37.75096538135834, item_longtitue: -122.39499911798262),Item(id: "003", item_name: "Italian Sausage", item_cost: 8, item_details: "Italian sausages with fennel seeds", item_image: "https://www.sipandfeast.com/wp-content/uploads/2021/10/Italian-sausage-potatoes-recipe-snippet.jpg", item_ratings: "5", item_lattitue: 37.777358920314185, item_longtitue: -122.42619924422566)]
    
    // Cart
    @Published var cartItems: [Cart] = []
    @Published var hasOrdered = false
    
    
    // Ordered Item
    @Published var details : [Cart] = []
    @Published var selectedItem: Item?
    
    //index
    @Published var locIndex:Int = 0
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Ask for permission
        locationManager.requestWhenInUseAuthorization()
        
        switch manager.authorizationStatus {
            
        case .authorizedAlways:
            print("Authorized")
            self.hasLocation = true
            manager.requestLocation()
        case .authorizedWhenInUse:
            print("Authorized")
            self.hasLocation = true
            manager.requestLocation()
        case .denied:
            print("Denied")
            self.hasLocation = false
        default:
            self.hasLocation = false
            print("Unknown")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Read user location
        self.userLocation = locations.last
        self.getLocation()
        //self.login()
    }
    
    func getLocation() {
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { (result, error) in
            guard let data = result else {return}
            var address = ""
            
            address += data.first?.name ?? ""
            address += ", "
            address += data.first?.locality ?? ""
            
            self.userAddress = address
            
        }
    }
    // Access database
    func checkBot(){
        self.botCheck = Int(arc4random_uniform(900000)) + 100000
    }
    
    func login() {
        Auth.auth().signInAnonymously() { (res, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            print("Success = \(res!.user.uid)")
            self.loggedIn.toggle()
        }
    }

    // Filter data
    func filterData() {
        withAnimation(.linear) {
            self.filteredItems = self.items.filter({ item in
                return item.item_name.lowercased().contains(self.search.lowercased())
            })
        }
        
    }
    
    // Update Cart
    func addToCart(item: Item) {
        self.items[getIndex(item: item, isCartIndex: false)].isAdded.toggle()
        self.filteredItems[getFilteredItemsIndex(item: item, isCartIndex: false)].isAdded.toggle()
        
        if item.isAdded {
            //remove
            self.cartItems.remove(at: getIndex(item: item, isCartIndex: true))
        } else {
            self.cartItems.append(Cart(item: item, quantity: 1))
        }
        
    }
    
    func getCurrentItem(item: Item) -> Item{
        return item
    }
    
    // Get index of item in items
    func getIndex(item: Item, isCartIndex: Bool) -> Int {
        let index = self.items.firstIndex { item1 -> Bool in
            return item.id == item1.id
        } ?? 0
        
        let cartIndex = self.cartItems.firstIndex { item1 -> Bool in
            return item.id == item1.item.id
        } ?? 0
        
        return isCartIndex ? cartIndex : index
    }
    
    // Get index of item in filteredItems
    func getFilteredItemsIndex(item: Item, isCartIndex: Bool) -> Int {
        let index = self.filteredItems.firstIndex { item1 -> Bool in
            return item.id == item1.id
        } ?? 0
        
        let cartIndex = self.cartItems.firstIndex { item1 -> Bool in
            return item.id == item1.id
        } ?? 0
        
        return isCartIndex ? cartIndex : index
    }
    
    // Convert from float to $ currency
    func getPrice(value: Float) -> String {
        let format = NumberFormatter()
        format.numberStyle = .currency
        return format.string(from: NSNumber(value: value)) ?? ""
    }

    // Calculate total price
    func calTotalPrice() -> String {
        var price: Float = 0
        
        cartItems.forEach { item in
            price += Float(item.quantity) * Float(truncating: item.item.item_cost)
        }
        return getPrice(value: price)
    }
    
    // Update order onto Firestore
    func updateOrder() {
        
        if(self.hasOrdered == false){
            for fooditem in cartItems{
                details.append(fooditem)
            }
        }
        else if(self.hasOrdered == true){
            for fooditem in cartItems{
                cartItems.remove(at: getIndex(item: fooditem.item, isCartIndex: true))
                details.remove(at: getIndex(item: fooditem.item, isCartIndex: true))
                self.items[getIndex(item: fooditem.item, isCartIndex: false)].isAdded.toggle()
                self.filteredItems[getFilteredItemsIndex(item: fooditem.item, isCartIndex: false)].isAdded.toggle()
            }
        }
        
        
        self.hasOrdered.toggle()
        print("Sucessful")
    }
}
