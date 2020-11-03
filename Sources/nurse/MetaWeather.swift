//
//  MetaWeather.swift
//  
//
//  Created by SwearWang on 2020/10/31.
//

import Foundation
import Combine

@available(OSX 10.15, *)
struct MetaWeather {
    
    static func location(by string: String) -> Future<[Location], Never> {

        return Future { promise in

            var locations = [Location]()
            // should encode url but it's unnecessary here
            let url = URL(string: "https://www.metaweather.com/api/location/search/?query=\(string)")!

            URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in

                guard error == nil, urlResponse != nil, data != nil else { return }
                
                if let httpURLResponse = urlResponse as? HTTPURLResponse,
                   let data = data {
                    
                    // output response headers for debugging
                    httpURLResponse.allHeaderFields.forEach { (key, value) in
                        print("\(key): \(value)")
                    }

                    let decoder = JSONDecoder()
                    locations = (try? decoder.decode([Location].self, from: data)) ?? []
                    promise(.success(locations))
                }

            }.resume()
        }
    }
}

struct Location: Codable {
    
    /// Name of the location
    var title: String
    
    /// Location type
    var locationType: String
    
    /// Comma separated lattitude and longitude e.g. "36.96,-122.02".
    var lattLong: String
    
    /// Where On Earth ID
    var woeid: Int
    
    /// Distance - Only returned on a lattlong search
    var distance: Int?
    
    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case lattLong = "latt_long"
        case woeid
        case distance
    }
    
}
