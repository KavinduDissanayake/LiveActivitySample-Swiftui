//
//  PassengerLiveActivityView.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-09.
//
import SwiftUI
import ActivityKit
import WidgetKit

// MARK: - PassengerLiveActivityView Component
struct PassengerLiveActivityView: View {
    let state: RideTrackingAttributes.ContentState

    var body: some View {
        VStack(spacing: .zero) {
            // ETA & Driver Info
            HStack {
                VStack(alignment: .leading) {
                    Text("\(state.estimatedArrival)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.green)
                    Text("\(state.travelStatus)")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                // Driver Profile & Car Image
                VStack {
                    Text("\(state.driverName)")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(state.carPlate)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text("\(state.carModel)")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                    
                }
            }
            Spacer()
            // Progress Bar Component
            ProgressBarView(progress: CGFloat(state.progressPercentage))
            
            Spacer()
        }
        .padding()
        .background(Color.black)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}


// MARK: - PassengerLiveActivity Widget
struct PassengerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RideTrackingAttributes.self) { context in
            PassengerLiveActivityView(state: context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    PassengerLiveActivityView(state: context.state)
                }
            } compactLeading: {
                HStack {
                    Text("\(context.state.estimatedArrival)")
                        .foregroundColor(.white)
                        .padding()
                }
            } compactTrailing: {
                HStack {
                    Text("\(context.state.progressPercentage)%")
                        .foregroundColor(.white)
                    Image(systemName: "clock.fill")
                        .foregroundColor(.yellow)
                }
            } minimal: {}
        }

    }
}





// MARK: - Previews
#Preview("Notification", as: .content, using: RideTrackingAttributes.preview) {
    PassengerLiveActivity()
} contentStates: {
    RideTrackingAttributes.ContentState.sample
}



#Preview("Dynamic Island Expanded", as: .dynamicIsland(.expanded), using: RideTrackingAttributes.preview) {
    PassengerLiveActivity()
} contentStates: {
    RideTrackingAttributes.ContentState.sample
}


#Preview("Dynamic Island Compact", as: .dynamicIsland(.compact), using: RideTrackingAttributes.preview) {
    PassengerLiveActivity()
} contentStates: {
    RideTrackingAttributes.ContentState.sample
}


