//
//  RideTrackingAttributes.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-09.
//


import ActivityKit
import Foundation

struct RideTrackingAttributes: Codable {
    public struct ContentState: RideTrackingType, Codable, Hashable {
        var progressPercentage: Int  // Ride progress (0% to 100%)
        var estimatedArrival: String // ETA string
        var driverName: String
        var travelStatus: String
        var carPlate: String
        var carModel: String
    }

    let id: String
}



extension RideTrackingAttributes: ActivityAttributes {}


extension RideTrackingAttributes {
     static var preview: RideTrackingAttributes {
        RideTrackingAttributes(id: UUID().uuidString)
    }
}

extension RideTrackingAttributes.ContentState {
     static var sample: RideTrackingAttributes.ContentState {
        .init(progressPercentage: 60,
              estimatedArrival: "5 min",
              driverName: "David", travelStatus: "On the way to pickup",
              carPlate: "7NL5091",
              carModel: "Renault Clio Blanche")
    }
}
