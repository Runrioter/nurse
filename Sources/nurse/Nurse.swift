//
//  Nurse.swift
//

import ArgumentParser

@available(OSX 10.15, *)
struct Nurse: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "nurse",
        abstract: """
            🏥 Nurse

              A Toy for learning Swift programming language.

            """,
        subcommands: [LocationSubcommand.self, WeatherSubcommand.self]
    )

}
