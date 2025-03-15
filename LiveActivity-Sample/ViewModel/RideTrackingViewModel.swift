//
//  RideTrackingViewModel.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-09.
//


import SwiftUI
import FirebaseFirestore
import ActivityKit

@Observable
@MainActor
class RideTrackingViewModel {
    private let db = Firestore.firestore()
    
     var progress: Double = 0
     var estimatedArrival: String = "Loading..."
     var showAlert: Bool = false
     var alertMessage: String = ""
    
    let rideId: String

    init(rideId:String) {
        self.rideId = rideId
        listenForFirestoreUpdates()
    }

    func listenForFirestoreUpdates() {
        db.collection("rides").document(rideId).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot, document.exists, let data = document.data() else {
                return
            }
            
            if let newProgress = data["progressPercentage"] as? Double,
               let newETA = data["estimatedArrival"] as? String {
                
                DispatchQueue.main.async {
                    self.progress = newProgress
                    self.estimatedArrival = newETA
                }
            }
        }
    }
}
