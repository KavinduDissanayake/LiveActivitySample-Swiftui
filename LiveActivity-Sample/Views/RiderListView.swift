//
//  RiderListView.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-09.


import SwiftUI
import FirebaseFirestore

struct RiderListView: View {
    @State private var viewModel = RiderListViewModel()

    var body: some View {
        VStack(spacing: .zero) {
            // List of Live Activities
            List(viewModel.allRides, id: \.id) { ride in
                Button(action: {
                    viewModel.selectRide(rideId: ride.id)
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Ride ID: \(ride.id)")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("ETA: \(ride.estimatedArrival)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 50, height: 50)
                            
                            Text("\(ride.progressPercentage)%")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 2))
                }
                .buttonStyle(PlainButtonStyle())
            }

            // Add New Ride Button
            Button(action: {
                viewModel.selectRide(rideId: nil)
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(hex: "#22C55E"))
            }
            .padding()
        }
        .sheet(isPresented: $viewModel.showBottomSheet) {
            RiderDetailsView(viewModel: RiderViewViewModel(rideId: viewModel.selectedRideId ?? UUID().uuidString))
//            RiderDetailsView(viewModel: RiderViewViewModel(rideId: "RIDE_4356"))
        }
        .navigationTitle("Live Activities")
        
    }
}


#Preview {
    NavigationView {
        RiderListView()
    }
}
