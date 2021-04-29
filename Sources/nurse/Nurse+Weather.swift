//
//  Nurse+Weather.swift
//

import ArgumentParser
import Combine
import Foundation

@available(OSX 10.15, *)
extension Nurse {
    struct WeatherSubcommand: ParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: "weather",
            abstract: "Search weather using MetaWeather API"
        )

        @Option(
            name: [.short],
            help: ArgumentHelp("Location. e.g., beijing", valueName: "location text")
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
