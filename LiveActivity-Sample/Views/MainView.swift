//
//  MainView.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-09.
//


import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            RiderListView()
        }
        .task { await ActivityManager.shared.requestPushPermissions() }
    }
}


#Preview {
    MainView()
}
