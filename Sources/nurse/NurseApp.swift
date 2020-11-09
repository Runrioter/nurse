//
//  NurseApp.swift
//

import ArgumentParser

@available(OSX 10.15, *)
struct NurseApp: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "nurse",
        abstract: """
            🏥 Nurse

              A Toy for learning Swift programming language.

            """,
        subcommands: [LocationSubcommand.self, WeatherSubcommand.self]
    )

}
