//
//  MetaWeather.swift
//

import Combine
import Foundation

@available(OSX 10.15, *)
struct MetaWeather {

    static func location(by location: String) -> Future<[Location], Error> {

        return Future { promise in

            let url = makeLocationURL(query: location)

            URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in

                if let error = error {
                    return promise(.failure(error))
                }

                if let httpURLResponse = urlResponse as? HTTPURLResponse,
                    let data = data
                {

                    // output response headers for debugging
                    httpURLResponse.allHeaderFields.forEach { (key, value) in
                        print("\(key): \(value)")
                    }

                    do {
                        let decoder = JSONDecoder()
                        let locations = try decoder.decode([Location].self, from: data)
                        promise(.success(locations))
                    } catch {
                        promise(.failure(error))
                    }
                }

            }.resume()
        }
    }

    private static func makeLocationURL(query: String) -> URL {
        var urlComponents = URLComponents(
            string: "https://www.metaweather.com/api/location/search/")!
        urlComponents.queryItems = [URLQueryItem(name: "query", value: query)]
        return urlComponents.url!
    }

}

struct Location: Codable {

    /// Name of the location
    var title: String

    /// Location type
    var locationType: String

    /// Comma separated lattitude and longitude e.g. "36.96,-122.02".
    var lattLong: LattLong

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

    struct LattLong: Codable, CustomStringConvertible {

        private var lattitude: Double

        private var longitude: Double

        var description: String {
            return "<\(lattitude),\(longitude)>"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let lattLong = try container.decode(String.self)
            let lattAndLongSlice = lattLong.split(separator: ",")
            lattitude = Double(lattAndLongSlice[0])!
            longitude = Double(lattAndLongSlice[1])!
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode("\(lattitude),\(longitude)")
        }

    }
}
