//
//  MetaWeather.swift
//

import Combine
import Foundation

@available(OSX 10.15, *)
struct MetaWeather {

    //    static let decoder: JSONDecoder = {
    //        let decoder = JSONDecoder()
    //        decoder.keyDecodingStrategy = .convertFromSnakeCase
    //        return decoder
    //    }()

    static let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        var headers = [
            "User-Agent":
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36",
            "Accept":
                "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
            "Accept-Encoding": "gzip, deflate, br",
            "Referer": "https://www.metaweather.com/api/",
        ]
        configuration.httpAdditionalHeaders = headers
        configuration.urlCache = .shared
        configuration.requestCachePolicy = .reloadRevalidatingCacheData
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        return URLSession(configuration: configuration)
    }()

    static func location(by location: String) -> Future<[Location], Error> {

        return Future { promise in

            let url = makeLocationURL(query: location)

            urlSession.dataTask(with: url) { (data, urlResponse, error) in

                if let error = error {
                    return promise(.failure(error))
                }

                if let _ = urlResponse as? HTTPURLResponse,
                    let data = data
                {

                    // output response headers for debugging
                    // httpURLResponse.allHeaderFields.forEach { (key, value) in
                    //     print("\(key): \(value)")
                    // }

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

    static func weather(by woeid: Int) -> Future<[Weather], Error> {
        return Future { promise in

            let url = makeWeatherURL(woeid: woeid)

            urlSession.dataTask(with: url) { (data, urlResponse, error) in

                if let error = error {
                    return promise(.failure(error))
                }

                if let _ = urlResponse as? HTTPURLResponse,
                    let data = data
                {

                    // output response headers for debugging
                    // httpURLResponse.allHeaderFields.forEach { (key, value) in
                    //     print("\(key): \(value)")
                    // }

                    do {
                        let decoder = JSONDecoder()
                        let detail = try decoder.decode(WeatherDetail.self, from: data)
                        promise(.success(detail.consolidatedWeather))
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

    private static func makeWeatherURL(woeid: Int) -> URL {
        let urlComponents = URLComponents(
            string: "https://www.metaweather.com/api/location/\(woeid)")!
        return urlComponents.url!
    }

}
