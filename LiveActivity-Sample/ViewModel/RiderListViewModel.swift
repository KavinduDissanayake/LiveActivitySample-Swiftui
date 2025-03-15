//
//  RiderListViewModel.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-09.
//
import SwiftUI
import FirebaseFirestore

@Observable
@MainActor
class RiderListViewModel {
    private let db = Firestore.firestore()
    
    var allRides: [RideTracking] = []
    var selectedRideId: String?
    var showBottomSheet: Bool = false

    init() {
        fetchLiveActivities()
    }

    func fetchLiveActivities() {
        db.collection("rides").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                return
            }

            DispatchQueue.main.async {
                self.allRides = documents.compactMap { doc in
                    let data = doc.data()
                    
                    guard let progress = data["progressPercentage"] as? Int,
                          let estimatedArrival = data["estimatedArrival"] as? String,
                          let driverName = data["driverName"] as? String,
                          let carPlate = data["carPlate"] as? String,
                          let carModel = data["carModel"] as? String else {
                        return nil
                    }
                    
                    //  Handle Travel Status (If Missing, Default to .onTheWayToPickup)
                    let travelStatusString = data["travelStatus"] as? String ?? TravelStatus.onTheWayToPickup.rawValue
                    let travelStatus = TravelStatus(rawValue: travelStatusString) ?? .onTheWayToPickup
                    
                    return RideTracking(
                        id: doc.documentID,
                        progressPercentage: progress,
                        estimatedArrival: estimatedArrival,
                        driverName: driverName,
                        carPlate: carPlate,
                        carModel: carModel,
                        travelStatus: travelStatus.rawValue
                    )
                }
            }
        }
    }
    

    func selectRide(rideId: String?) {
        selectedRideId = rideId
        showBottomSheet = true
    }
}
