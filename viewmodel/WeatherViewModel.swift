//
//  WeatherViewModel.swift
//  USMAN_Weather
//
//  Created by mac owner on 2020-11-26.
//

import Foundation
import MapKit

class WeatherViewModel : ObservableObject{
    @Published var weatherItem = Weather()
    private var parkingCoordinates = CLLocationCoordinate2D()
    private var lat: Double =  0.0
    private var lng: Double = 0.0
    private var apiURLString : String = ""

   
    
    func fetchDataFromAPI(_lat:Double,_lng:Double){
        self.lat = _lat
        self.lng = _lng
        apiURLString = createApiURL()
        //save url we need in apiURL // guard keep running after closure
        guard let apiURL = URL(string: apiURLString) else{
            return
        }
        //data fetching services
        URLSession.shared.dataTask(with: apiURL){
            //3 properties needed in this closure
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let er = error{
                print("first error message")
                print(#function, "Error \(er.localizedDescription)")
                
            }else{
                //received data or response //put in queue of requests attached to our global app namespace
                DispatchQueue.global().async {
                    do{
                        if let jsonData = data{
                            //we received data in JSON
                            
                            //start decoding
                            let decoder = JSONDecoder()
                            
                            let decodedList = try decoder.decode(Weather.self, from: jsonData)
                            
                            //you cannot publish any changes from the background thread
                            DispatchQueue.main.async {
                                self.weatherItem = decodedList
                                print(#function, self.weatherItem)
                            }
                            print(#function,"Hi\n")
                            
                        }else{
                            print(#function, "JSON data is empty")
                        }
                    }catch let error{
                        print("last error message")
                        print(#function, "Error decoding the data \(error.localizedDescription)")
                       

                    }
                }
            }
            
        }.resume() //wont run api data without resume()
    }
    func createApiURL()->String{
        print(#function,"https://api.aerisapi.com/observations/\(self.lat),\(self.lng)?query&client_id=cLNUnS8ZaE4mB8PfUZS3u&client_secret=KfqWo0K090Bx0Vx5c8pbZTJYfF30gfdFPDEFvBQW")
        return "https://api.aerisapi.com/observations/\(self.lat),\(self.lng)?query&client_id=cLNUnS8ZaE4mB8PfUZS3u&client_secret=KfqWo0K090Bx0Vx5c8pbZTJYfF30gfdFPDEFvBQW"
    }
}
