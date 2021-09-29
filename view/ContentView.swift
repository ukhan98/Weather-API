//
//  ContentView.swift
//  USMAN_Weather
//
//  Created by mac owner on 2020-11-25.
//


import SwiftUI
import MapKit

struct ContentView: View {
    
    @ObservedObject var weatherViewModel = WeatherViewModel()
    @ObservedObject var locationManager = LocationManager()
    @State private var deviceCoordinates = CLLocationCoordinate2D()
    @State private var location:String=""
    @State private var lat = 0.0
    @State private var lng = 0.0
    
    
    var body: some View {
        NavigationView{
            
            VStack(alignment: .leading, spacing: 20){
                HStack{
                    Text("\(self.updateView()), \(locationManager.state!)").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .bold().font(.system(size: 60))
                }
                Spacer()
                HStack{
                    Text("Temprature").font(.system(size: 35))
                    Text(String(format:"%.2fC", (WeatherViewModel.WeatherObj.temprature)))
                        .font(.system(size: 35)).foregroundColor(.red)
                }
                HStack{
                    Text("Feels like").font(.system(size: 35))
                    Text(String(format: " %.2fC", (WeatherViewModel.WeatherObj.feelsLike))).font(.system(size: 35)).foregroundColor(.red)
                }
                HStack{
                    Text("Dewpoint").font(.system(size: 35))
                    Text(String(format:" %.2f", (WeatherViewModel.WeatherObj.dewpoint))).font(.system(size: 35)).foregroundColor(.red)
                }
                HStack{
                    Text("Humidity").font(.system(size: 35))
                    Text(String(format:" %.2f",
                            (WeatherViewModel.WeatherObj.humidity))
                ).font(.system(size: 35)).foregroundColor(.red)
                }
                
                HStack{
                    Text("Wind Speed ").font(.system(size: 35))
                    Text(String(format:"%.2fKPH", (WeatherViewModel.WeatherObj.windSpeed))).font(.system(size: 35)).foregroundColor(.red)
                }
                HStack{
                    Text("Visibility").font(.system(size: 35))
                    Text(String(format:" %.2f", (WeatherViewModel.WeatherObj.visability))).font(.system(size: 35)).foregroundColor(.red)
                }
                Spacer()
           // }
            }
            
            .navigationBarTitle(Text ("Mikhail_Ajaj"))
            
        }
        
        .onAppear(){
            if (self.lat != 0 && self.lng != 0){
                self.deviceCoordinates = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
            }
            else{
                //obtain lat and lng using geocoding
                self.locationManager.getCoordinates(address: self.location, completionHandler: { (coordinates, error) in
                    
                    if (error == nil){
                        //sucessfully obtained coordinates
                        self.deviceCoordinates = coordinates
                        print(#function, "Coordinates obtained :", self.deviceCoordinates)
                    }else{
                        //prompt the user of unavailable address or route
                        print(#function, "error: ", error?.localizedDescription as Any)
                    }
                    
                })
            }
            
            weatherModelView.fetchDataFromAPI(_lat:locationManager.lat,_lng:locationManager.lng)
        }
        
    
    }
    func updateView()->String{
        weatherModelView.fetchDataFromAPI(_lat:locationManager.lat,_lng:locationManager.lng)
        return locationManager.getCity()!
    }
    func style(str: String) -> Text {
        return Text("\(str)").foregroundColor(.red)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
