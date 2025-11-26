//
//  Standford_Course_2025App.swift
//  Standford Course 2025
//
//  Created by visortix on 26.11.2025.
//

import SwiftUI
import CoreData

@main
struct Standford_Course_2025App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
