//
//  Recipe_ViewerApp.swift
//  Recipe Viewer
//
//  Created by David Mehedinti on 12/10/24.
//

import SwiftUI
import SwiftData

@main
struct Recipe_ViewerApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: RecipeEntity.self)
    }
}
