//
//  StartUpSwiftUiEp0App.swift
//  StartUpSwiftUiEp0
//
//  Created by Jupyter on 17/5/26.
//

import SwiftUI

@main
struct StartUpSwiftUiEp0App: App {
    @StateObject private var connectivityMonitor = ConnectivityMonitor()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(connectivityMonitor)
        }
    }
}
