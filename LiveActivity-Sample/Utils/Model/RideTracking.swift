//
//  RideTrackingType.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-09.
//


protocol RideTrackingType {
    var progressPercentage: Int { get }
    var estimatedArrival: String { get }
    var driverName: String { get }
    var carPlate: String { get }
    var carModel: String { get }
    var travelStatus: String { get }
}

struct RideTracking: RideTrackingType, Codable, Identifiable, Hashable {
    var id: String
    var progressPercentage: Int
    var estimatedArrival: String
    var driverName: String
    var carPlate: String
    var carModel: String
    var travelStatus: String
}
