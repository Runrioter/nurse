//
//  NurseAppExtension.swift
//

import Foundation
import Combine
import ArgumentParser

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
            
            MetaWeather.location(by: query).sink(receiveCompletion: { completion in

                switch completion {
                case .finished:
                    // ignore
                break
                case .failure(let error):
                    print("received the error: ", error.localizedDescription)
                }
                
                semaphore.signal()
                
            }, receiveValue: { locations in

                print("\n=== Locations ===")
                locations.forEach { outputLocation($0) }
                print("=== Total: \(locations.count) ===\n")

            }).store(in: &cancellable)


            semaphore.wait()
        }
        
    }

}

func outputLocation(_ location: Location) {
    print("""
    Title: \(location.title)
    Location Type: \(location.locationType)
    Lattlong: \(location.lattLong)
    Woeid: \(location.woeid)
    Distance: \(location.distance ?? 0)
    """)
}
