//
//  ContentView.swift
//  RestaurantsSwiftUI
//
//  Created by Aitzhan Ramazan on 24.08.2024.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI

struct Restaurants: Identifiable{
    var id = UUID()
    var name = ""
    var location = ""
    var street = ""
    var image = ""
    
    init(json: JSON){
        if let item = json["name"].string{
            name = item
        }
        if let item = json["location"].string{
            location = item
        }
        if let item = json["street"].string{
            street = item
        }
        if let item = json["image"].string{
            image = item
        }
    }
}
struct RestaurantsRow: View {
    var restauranrItem: Restaurants
    var body: some View {
        HStack{
            WebImage(url: URL(string: restauranrItem.image))
                .resizable()
                .frame(width: 120, height: 120)
                .cornerRadius(7)
            VStack(alignment: .leading){
                Text("Name: \(restauranrItem.name)")
                
                Text("Location: \(restauranrItem.location)")
                
                Text("Street: \(restauranrItem.street)")
                
            }
            .padding(.leading)
        }
        .padding(.vertical)
    }
}

struct ContentView: View {
    @ObservedObject var restaurantsList = GetRestaurants()
    var body: some View {
        
        NavigationView{
            List(restaurantsList.restaurantArray){ restaurantItem in
                RestaurantsRow(restauranrItem: restaurantItem)
            }
            .navigationTitle("Restaurants")
        }
    }
}

class GetRestaurants: ObservableObject{
    @Published var restaurantArray = [Restaurants]()
    init(){
        updateData()
    }
    func updateData(){
        let urlString = "https://demo9533241.mockable.io/getRestaurants"
        
        let url = URL(string: urlString)
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url!) {(data, _, error) in
            
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            let json = try! JSON(data: data!)
            if let resultArray = json.array{
                for item in resultArray{
                    let restaurantItem = Restaurants(json: item)
                    DispatchQueue.main.async {
                        self.restaurantArray.append(restaurantItem)
                    }
                   
                }
               
            }
        }.resume()
        
    }
    
}


#Preview {
    ContentView()
}

