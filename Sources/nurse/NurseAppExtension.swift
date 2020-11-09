//
//  NurseAppExtension.swift
//

import ArgumentParser
import Combine
import Foundation

@available(OSX 10.15, *)
extension NurseApp {

    struct LocationSubcommand: ParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: "location",
            abstract: "Search locations using MetaWeather API"
        )

        @Option(
            name: [.short],
            help: ArgumentHelp("Location to search for.", valueName: "location text")
        )
        var query: String

        mutating func run() throws {

            var cancellable = Set<AnyCancellable>()

            let semaphore = DispatchSemaphore(value: 0)

            MetaWeather.location(by: query).sink(
                receiveCompletion: { completion in

                    switch completion {
                    case .finished:
                        // ignore
                        break
                    case .failure(let error):
                        print("received the error: ", error.localizedDescription)
                    }

                    semaphore.signal()

                },
                receiveValue: { locations in

                    print("\n=== Locations ===")
                    locations.forEach { outputLocation($0) }
                    print("=== Total: \(locations.count) ===\n")

                }
            ).store(in: &cancellable)

            semaphore.wait()
        }

    }

    struct WeatherSubcommand: ParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: "weather",
            abstract: "Search weather using MetaWeather API"
        )

        @Option(
            name: [.short],
            help: ArgumentHelp("Location for searching for weather.", valueName: "location text")
        )
        var query: String

        mutating func run() throws {

            var cancellable = Set<AnyCancellable>()

            let semaphore = DispatchSemaphore(value: 0)

            MetaWeather.location(by: query).sink(
                receiveCompletion: { completion in

                    switch completion {
                    case .finished:
                        // ignore
                        break
                    case .failure(let error):
                        print("received the error: ", error.localizedDescription)
                        semaphore.signal()
                    }

                },
                receiveValue: { locations in

                    locations.forEach {
                        let woeid = $0.woeid
                        MetaWeather.weather(by: woeid).sink { (completion) in
                            switch completion {
                            case .finished:
                                // ignore
                                break
                            case .failure(let error):
                                print("received the error: ", error)
                            }

                            semaphore.signal()
                        } receiveValue: { weathers in

                            print("\n=== Weathers ===")
                            weathers.forEach { outputWeather($0) }
                            print("=== Total: \(weathers.count) ===\n")

                        }.store(in: &cancellable)
                    }

                }
            ).store(in: &cancellable)

            semaphore.wait()
        }

    }

}

// ☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️
private func weatherIcon(_ abbr: String) -> String {
    switch abbr {
    case "c":
        return "☀️"
    case "lc":
        return "🌤"
    case "hc":
        return "☁️"
    case "s":
        return "🌦"
    case "lr":
        return "🌧"
    case "hr":
        return "⛈"
    case "t":
        return "🌩"
    case "h":
        return "🌨"
    case "sl":
        return "🌨"
    case "sn":
        return "❄️"
    default:
        return abbr
    }
}

func outputWeather(_ weather: Weather) {
    let icon = weatherIcon(weather.weatherStateAbbr)

    print(
        """
        Weather State: \(icon)
        Current Temp: \(weather.theTemp)
        Temp Range: \(weather.minTemp) ~ \(weather.maxTemp)
        Wind Speed: \(weather.windSpeed)
        Humidity: \(weather.humidity)
        Air Pressure: \(weather.airPressure)
        Predictability: \(weather.predictability)
        Visibility: \(weather.visibility)
        """)
}

func outputLocation(_ location: Location) {

    print(
        """
        Title: \(location.title)
        Location Type: \(location.locationType)
        Lattlong: \(location.lattLong)
        Woeid: \(location.woeid)
        Distance: \(location.distance ?? 0)
        """)
}
