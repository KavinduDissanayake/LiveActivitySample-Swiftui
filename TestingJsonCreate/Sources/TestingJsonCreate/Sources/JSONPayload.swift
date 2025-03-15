//
//  JSONPayload.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-13.
//

import ArgumentParser

@main
struct JSONPayload: ParsableCommand {
    @Argument(help: "Which step of the live activity cycle to generate as JSON")
    var step: Int

    @Flag(help: "Prints date in a human-readable style")
    var debug: Bool = false

    mutating func run() throws {
        let jsonString = switch step {
        case 1: try beforeRide(debug: debug)
        case 2: try updateRide(debug: debug)
        case 3: try endRide(debug: debug)
        default:
            fatalError("No step '\(step)' defined")
        }

        print(jsonString)
    }
}
