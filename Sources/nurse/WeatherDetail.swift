//
//  WeatherDetail.swift
//
import Foundation

struct WeatherDetail: Codable {
  var woeid: Int
  var lattLong: Location.LattLong
  var locationType: String
  var title: String
  var sources: [Source]
  var parent: Location
  var timezoneName: String
  var timezone: String
  //    var sunSet: Date
  //    var sunRise: Date
  //    var time: Date
  var consolidatedWeather: [Weather]

  enum CodingKeys: String, CodingKey {
    case title
    case locationType = "location_type"
    case lattLong = "latt_long"
    case woeid
    case sources
    case parent
    case timezoneName = "timezone_name"
    case timezone
    //        case sunSet = "sun_set"
    //        case sunRise = "sun_rise"
    //        case time
    case consolidatedWeather = "consolidated_weather"
  }
}
