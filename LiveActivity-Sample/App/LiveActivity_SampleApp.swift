//
//  LiveActivity_SampleApp.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-09.
//

import SwiftUI

@main
struct LiveActivity_SampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainView.init()
        }
    }
}
