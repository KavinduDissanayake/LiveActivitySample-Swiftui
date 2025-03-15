//
//  RiderDetailsView.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-09.
//
import SwiftUI
import FirebaseFirestore

struct RiderDetailsView: View {
    @State var viewModel: RiderViewViewModel = .init(rideId: "RIDE_4356") 
    
    var body: some View {
        NavigationView {
            Form { //  Wrapped content inside Form for better UI
                // Ride Details
                Section(header: Text("Ride Details")) {
                    Text("Ride #\(viewModel.rideId)")
                        .font(.subheadline)
                        .bold()
                }
                
                // Travel Status Picker
                Section(header: Text("Travel Status")) {
                    Picker("Travel Status", selection: $viewModel.travelStatus) {
                        ForEach(TravelStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) //  Shows as a menu
                    .onChange(of: viewModel.travelStatus) { _, _ in
                        viewModel.updateFirestore()
                    }
                }
                
                // Progress Slider
                Section(header: Text("Progress")) {
                    Slider(value: $viewModel.progress, in: 0...100, step: 1)
                        .onChange(of: viewModel.progress) { _, _ in
                            viewModel.updateFirestore()
                        }
                    Text("Current Progress: \(Int(viewModel.progress))%")
                        .font(.headline)
                }
                
                // ETA Input Field
                Section(header: Text("ETA")) {
                    HStack {
                        Picker("Hours", selection: $viewModel.selectedHours) {
                            ForEach(0..<24, id: \.self) { hour in
                                Text("\(hour) hr").tag(hour)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: 100)
                        
                        Picker("Minutes", selection: $viewModel.selectedMinutes) {
                            ForEach([0, 10, 20, 30, 40, 50], id: \.self) { minute in
                                Text("\(minute) min").tag(minute)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: 100)
                    }
                    .onChange(of: viewModel.selectedHours) { _, _ in viewModel.updateETA() }
                    .onChange(of: viewModel.selectedMinutes) { _, _ in viewModel.updateETA() }
                    
                    Text("ETA: \(viewModel.eta)")
                        .foregroundColor(.gray)
                }
                
                // Driver Information
                Section(header: Text("Driver Information")) {
                    TextField("Driver Name", text: $viewModel.driverName)
                        .onChange(of: viewModel.driverName) { _, _ in
                            viewModel.updateFirestore()
                        }
                    TextField("Car Plate", text: $viewModel.carPlate)
                        .onChange(of: viewModel.carPlate) { _, _ in
                            viewModel.updateFirestore()
                        }
                    TextField("Car Model", text: $viewModel.carModel)
                        .onChange(of: viewModel.carModel) { _, _ in
                            viewModel.updateFirestore()
                        }
                }
                
                // Save & Delete Buttons
                Section {
                    Button(action: {
                        viewModel.updateFirestore()
                    }) {
                        Text("Submit Ride Details")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        viewModel.deleteRide()
                    }) {
                        Text("Delete Ride")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                
                // Live Activity Buttons
                Section {
                    Button(action: {
                        ActivityManager.shared.startActivity(ride: RideTracking(
                            id: viewModel.rideId,
                            progressPercentage: Int(viewModel.progress),
                            estimatedArrival: viewModel.eta,
                            driverName: viewModel.driverName,
                            carPlate: viewModel.carPlate,
                            carModel: viewModel.carModel,
                            travelStatus: viewModel.travelStatus.rawValue
                        ))
                    }) {
                        Text("Start Live Activity")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        ActivityManager.shared.updateActivity(ride: RideTracking(
                            id: viewModel.rideId,
                            progressPercentage: Int(viewModel.progress),
                            estimatedArrival: viewModel.eta,
                            driverName: viewModel.driverName,
                            carPlate: viewModel.carPlate,
                            carModel: viewModel.carModel,
                            travelStatus: viewModel.travelStatus.rawValue
                        ))
                    }) {
                        Text("Update Live Activity")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Ride Details")
            .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}

//  Updated Preview
#Preview {
    RiderDetailsView()
}
