//
//  CuriousEdinburghAPI.swift
//  Curious Edinburgh
//
//  Created by Colin Gormley on 13/04/2016.
//  Copyright © 2016 Edina. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper


class _CuriousEdinburghAPI {
    
    init() {
  
    }
    
    func posts() {
        // Return some posts

        /*Alamofire.request(.GET, Constants.API.url).responseObject { (response: Response<WeatherResponse, NSError>) in
            
            let weatherResponse = response.result.value
            print(weatherResponse?.location)
            
            if let threeDayForecast = weatherResponse?.threeDayForecast {
                for forecast in threeDayForecast {
                    print(forecast.day)
                    print(forecast.temperature)           
                }
            }
        }*/
    }
    
   }

let curiousEdinburghAPI = _CuriousEdinburghAPI()