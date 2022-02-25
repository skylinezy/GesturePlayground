//
//  GesturePlaygroundApp.swift
//  GesturePlayground
//
//  Created by Ryan Zi on 9/30/21.
//

import SwiftUI

@main
struct GesturePlaygroundApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                TrailingSnapArea()
                    .tabItem {
                        Text("Trailing Snap Area")
                    }
                SurroundSnapArea()
                    .tabItem {
                        Text("Surrounding Snap Area")
                    }
            }
        }
    }
}
