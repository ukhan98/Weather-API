//
//  Weather.swift
//  USMAN_Weather
//
//  Created by mac owner on 2020-11-25.
//

import Foundation

struct Weather : Codable,Identifiable{
    var id: String?
    var temprature: Double
    var feelsLike: Double
    var dewpoint: Double
    var humidity: Double
    var windSpeed: Double
    var visability: Double
    init() {
        id = ""
        temprature = 0.0
        feelsLike = 0.0
        dewpoint = 0.0
        humidity = 0.0
        windSpeed = 0.0
        visability = 0.0
        
    }
    enum CodingKeys: String, CodingKey{
        case response = "response"
        case long = "long"
        case id = "id"
        case temprature = "tempC"
        case feelsLike = "feelslikeC"
        case dewpoint = "dewpointC"
        case humidity = "humidity"
        case windSpeed = "windKPH"
        case visability = "visibilityKM"
        case ob = "ob"
        
    }
    init(from decoder: Decoder) throws {

        let ObjectContatiner = try decoder.container(keyedBy: CodingKeys.self)
        let response = try ObjectContatiner.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        //id
        self.id = try response.decodeIfPresent(String.self, forKey: .id)
        
        let ob = try response.nestedContainer(keyedBy: CodingKeys.self, forKey: .ob)
        
        self.temprature = try ob.decodeIfPresent(Double.self, forKey: .temprature)!
        self.feelsLike = try ob.decodeIfPresent(Double.self, forKey: .feelsLike)!
        self.dewpoint = try ob.decodeIfPresent(Double.self,forKey: .dewpoint)!
        self.humidity = try ob.decodeIfPresent(Double.self, forKey: .humidity)!
        self.windSpeed = try ob.decodeIfPresent(Double.self, forKey: .windSpeed)!
        self.visability = try ob.decodeIfPresent(Double.self, forKey: .visability)!
    }
    func encode(to encoder: Encoder) throws {
        //Nothing to encode
    }
}


//Api Stucture-Data
//
/*
 {
    "success":true, # check
    "error":null,
    "response":{  #secound level
       "id":"KNYC", #needed id
       "dataSource":"METAR_NOAA",
       "loc":{ #third  level
          "long":-73.966666666667, #needed 0.1
          "lat":40.783333333333    #needed 0.2
       },
       "place":{
          "name":"nyc\/central park",
          "city":"nyc\/central park",
          "state":"ny", #needed 1.1
          "country":"us"
       },
       "profile":{
          "tz":"America\/New_York",
          "tzname":"EST",
          "tzoffset":-18000,
          "isDST":false,
          "elevM":11,
          "elevFT":36
       },
       "obTimestamp":1604631060,
       "obDateTime":"2020-11-05T21:51:00-05:00",
       "ob":{
          "type":"station",
          "timestamp":1604631060,
          "dateTimeISO":"2020-11-05T21:51:00-05:00",
          "recTimestamp":1604631375,
          "recDateTimeISO":"2020-11-05T21:56:15-05:00",
          "tempC":15.6, #needed 2
          "tempF":60,
          "dewpointC":9.4, #needed 4
          "dewpointF":49,
          "humidity":67, #needed 5
          "pressureMB":1027,
          "pressureIN":30.33,
          "spressureMB":1027,
          "spressureIN":30.32,
          "altimeterMB":1028,
          "altimeterIN":30.36,
          "windKTS":3,
          "windKPH":6, #needed 6
          "windMPH":3,
          "windSpeedKTS":3,
          "windSpeedKPH":6,
          "windSpeedMPH":3,
          "windDirDEG":-1,
          "windDir":"VRB",
          "windGustKTS":null,
          "windGustKPH":null,
          "windGustMPH":null,
          "flightRule":"VFR",
          "visibilityKM":16.0934, #needed 7
          "visibilityMI":10,
          "weather":"Clear",
          "weatherShort":"Clear",
          "weatherCoded":"::CL",
          "weatherPrimary":"Clear",
          "weatherPrimaryCoded":"::CL",
          "cloudsCoded":"CL",
          "icon":"clearn.png",
          "heatindexC":15.6,
          "heatindexF":60,
          "windchillC":15.6,
          "windchillF":60,
          "feelslikeC":15.6, #needed 3
          "feelslikeF":60,
          "isDay":false,
          "sunrise":1604575908,
          "sunriseISO":"2020-11-05T06:31:48-05:00",
          "sunset":1604612829,
          "sunsetISO":"2020-11-05T16:47:09-05:00",
          "snowDepthCM":null,
          "snowDepthIN":null,
          "precipMM":0,
          "precipIN":0,
          "solradWM2":0,
          "solradMethod":"estimated",
          "ceilingFT":null,
          "ceilingM":null,
          "light":0,
          "uvi":null,
          "QC":"O",
          "QCcode":10,
          "trustFactor":100,
          "sky":0
       },
       "raw":"METAR KNYC 060251Z AUTO VRB03KT 10SM CLR 16\/09 A3036 RMK AO2 SLP271 T01560094 58004 $",
       "relativeTo":{
          "lat":40.759211,
          "long":-73.984638,
          "bearing":29,
          "bearingENG":"NNE",
          "distanceKM":3.08,
          "distanceMI":1.914
       }
    }
 }

 */
