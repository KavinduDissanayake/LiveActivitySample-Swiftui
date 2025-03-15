//
//  RiderViewViewModel.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-09.
//
import SwiftUI
import FirebaseFirestore

enum TravelStatus: String, Codable, CaseIterable {
    case accepted = "Accepted"
    case onTheWayToPickup = "On the way to pickup"
    case arrivedAndPickup = "Arrived and picked up"
    case onTheWayToDrop = "On the way to drop"
    case completed = "Ride Completed"
    case canceled = "Canceled"
}

@Observable
@MainActor
class RiderViewViewModel {
    private let db = Firestore.firestore()
    
    var progress: Double = 0
    var eta: String = "50 min"
    var etaDate: Date = Date()
    var driverName: String = "Kavindu"
    var carPlate: String = "CVB-123"
    var carModel: String = "Civic"
    var travelStatus: TravelStatus = .accepted
    
    
    var selectedHours: Int = 0 
    var selectedMinutes: Int = 10
    
    var showAlert: Bool = false
    var alertMessage: String = ""
    
    let rideId: String
    
    init(rideId: String) {
        self.rideId = rideId
        fetchRideDetails()
    }
    
    func fetchRideDetails() {
        db.collection("rides").document(rideId).getDocument { document, error in
            guard let data = document?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.progress = data["progressPercentage"] as? Double ?? 0
                self.eta = data["estimatedArrival"] as? String ?? ""
                self.driverName = data["driverName"] as? String ?? ""
                self.carPlate = data["carPlate"] as? String ?? ""
                self.carModel = data["carModel"] as? String ?? ""
                
                //  Load TravelStatus from Firestore (defaults to .onTheWayToPickup)
                if let statusString = data["travelStatus"] as? String,
                   let status = TravelStatus(rawValue: statusString) {
                    self.travelStatus = status
                }
            }
        }
    }
    
    func updateETA() {
          eta = selectedHours > 0 ? "\(selectedHours) hr \(selectedMinutes) min" : "\(selectedMinutes) min"
          updateFirestore()
      }
    
    func updateFirestore() {
        guard !eta.isEmpty,
              !driverName.isEmpty,
              !carPlate.isEmpty,
              !carModel.isEmpty,
              carModel.count >= 3 else {
            return
        }
        db.collection("rides").document(rideId).setData([
            "progressPercentage": Int(progress),
            "estimatedArrival": eta,
            "driverName": driverName,
            "carPlate": carPlate,
            "carModel": carModel,
            "travelStatus": travelStatus.rawValue,  // ✅ Save travelStatus as a String
            "liveActivityToken": AppData.liveActivityToken ?? "",
            "deviceToken": AppData.deviceToken ?? ""
        ], merge: true) { [self] error in
            if let error = error {
                self.alertMessage = "❌ Update Failed: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
    
    func deleteRide() {
        db.collection("rides").document(rideId).delete { error in
            if let error = error {
                self.alertMessage = "❌ Error deleting ride: \(error.localizedDescription)"
                self.showAlert = true
            } else {
                self.alertMessage = "✅ Ride deleted successfully!"
                self.showAlert = true
            }
        }
    }
}
