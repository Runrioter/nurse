//
//  Nurse+Location.swift
//

import ArgumentParser
import Combine
import Foundation

@available(OSX 10.15, *)
extension Nurse {

    struct LocationSubcommand: ParsableCommand {

        static let configuration = CommandConfiguration(
            commandName: "location",
            abstract: "Search locations using MetaWeather API"
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
