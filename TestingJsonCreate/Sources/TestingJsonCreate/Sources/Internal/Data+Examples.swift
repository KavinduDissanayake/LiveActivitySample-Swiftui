//
//  File.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-13.
//
import Foundation


func beforeRide(debug: Bool) throws -> String {
    let push = PushPayload(
        aps: StartApsContent(
            contentState: RideTrackingAttributes.ContentState(
                progressPercentage: 0,
                estimatedArrival: "Waiting for Driver",
                driverName: "Kavindu",
                travelStatus: "Trip Accpted",
                carPlate: "CAB-123",
                carModel: "Civic"
            ),
            attributesType: "RideTrackingAttributes",
            attributes: RideTrackingAttributes(id: UUID().uuidString)
        )
    )
    
    let data = try JSONEncoder.pushDecoder(debug: debug).encode(push)
    return try data.prettyPrintedJSONString
}

func updateRide(debug: Bool) throws -> String {
    let push = PushPayload(
        aps: UpdateApsContent(
            contentState: RideTrackingAttributes.ContentState(
                progressPercentage: 10,
                estimatedArrival: "Driver Has been arrived",
                driverName: "Kavindu",
                travelStatus: "On the way to pickup",
                carPlate: "CAB-123",
                carModel: "Civic"
            )
     )
    )
    
    let data = try JSONEncoder.pushDecoder(debug: debug).encode(push)
    return try data.prettyPrintedJSONString
}

func endRide(debug: Bool) throws -> String {
    let push = PushPayload(
        aps: EndApsContent(
            contentState: RideTrackingAttributes.ContentState(
                progressPercentage: 100,
                estimatedArrival: "Arrived",
                driverName: "Completed",
                travelStatus: "Driver Arrived",
                carPlate: "-",
                carModel: "-"
            )
        )
    )
    
    let data = try JSONEncoder.pushDecoder(debug: debug).encode(push)
    return try data.prettyPrintedJSONString
}



protocol RideTrackingType {
    var progressPercentage: Int { get }
    var estimatedArrival: String { get }
    var driverName: String { get }
    var carPlate: String { get }
    var carModel: String { get }
}

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
