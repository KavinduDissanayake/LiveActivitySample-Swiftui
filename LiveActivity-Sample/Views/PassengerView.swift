//
//  PassengerView.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-09.
//


import SwiftUI

struct PassengerView: View {
    @State private var viewModel: RideTrackingViewModel = .init(rideId: "RIDE_4356") // this sould be comes from backend
    var body: some View {
           VStack {
               // Ride Info Card
               VStack(spacing: 12) {
                   Text("Your Ride is On the Way! 🚖")
                       .font(.title3)
                       .bold()
                       .foregroundColor(.white)

                   HStack {
                       Image(systemName: "location.fill")
                           .foregroundColor(.white)
                       Text("Dropoff at **\(viewModel.estimatedArrival)**")
                           .font(.headline)
                           .foregroundColor(.white)
                   }

                   HStack {
                       Image(systemName: "car.fill")
                           .foregroundColor(.white)
                       Text("ETA: **\(viewModel.estimatedArrival)**")
                           .font(.subheadline)
                           .foregroundColor(.white.opacity(0.8))
                   }
               }
               .padding()
               .frame(maxWidth: .infinity)
               .background(LinearGradient(colors: [Color(hex: "#22C55E"), Color(hex: "#16A34A")], startPoint: .topLeading, endPoint: .bottomTrailing))
               .cornerRadius(15)
               .shadow(radius: 10)
               .padding(.horizontal)

               Spacer()

               // Animated Car Progress
               VStack {
                   Text("Driver is En Route 🚗")
                       .font(.headline)
                       .padding(.bottom, 8)
                   
                   ZStack(alignment: .leading) {
                       RoundedRectangle(cornerRadius: 5)
                           .frame(height: 10)
                           .foregroundColor(.gray.opacity(0.3))

                       RoundedRectangle(cornerRadius: 5)
                           .frame(width: max(CGFloat(viewModel.progress) * 3, 0), height: 10) // Prevents negative width
                           .foregroundColor(Color(hex: "#22C55E"))
                           .animation(.easeInOut(duration: 1.5), value: viewModel.progress)

                       Image(.icCarIcon) // Car icon
                           .resizable()
                           .frame(width: 49, height: 20)
                           .foregroundColor(.black)
                           .offset(x: max(CGFloat(viewModel.progress) * 3 - 24, 0)) // Ensures smooth movement
                           .animation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.5), value: viewModel.progress)
                   }
                   .padding(.horizontal)
               }

               Spacer()

               // Bottom Actions
               VStack(spacing: 12) {
                   Button(action: {}) {
                       Text("Call Driver 📞")
                           .bold()
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(Color(hex: "#22C55E"))
                           .foregroundStyle(.white)
                           .cornerRadius(10)
                   }
                   
                   Button(action: {}) {
                       Text("Cancel Ride ❌")
                           .bold()
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(Color.red)
                           .foregroundColor(.white)
                           .cornerRadius(10)
                   }
               }
               .padding(.horizontal)

           }
           .navigationTitle("Passenger View")
       }
}


#Preview {
    NavigationView {
        PassengerView()
    }
}
