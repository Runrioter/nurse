//
//  Nurse+Operation.swift
//

import ArgumentParser
import Combine
import Foundation

@available(OSX 10.15, *)
extension Nurse {

  struct OperationSubcommand: ParsableCommand {

    struct ListSubSubCommand: ParsableCommand {
      static var configuration: CommandConfiguration = CommandConfiguration(
        commandName: "list",
        abstract: "List command"
      )
    }

    static let configuration = CommandConfiguration(
      commandName: "operation",
      abstract: "Play operation",
      subcommands: [ListSubSubCommand.self]
    )

    @Option(
      name: [.short],
      help: ArgumentHelp("Exercise Operation", valueName: "Operation")
    )
    var query: String?

    mutating func run() throws {
      print("$ query: \(query ?? "default")")

      let dp = DispatchQueue(label: "io.github.runrioter.nurse")

      print("===")
      dp.sync {
        print("SYNC OUTER B >>> <\(Thread.current)>")
        dp.async {
          print("ASYNC INNER >>> <\(Thread.current)>")
        }
        print("SYNC OUTER E >>> <\(Thread.current)>")
      }
      sleep(2)
    }

  }

}
