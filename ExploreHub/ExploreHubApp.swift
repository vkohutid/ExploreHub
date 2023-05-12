//
//  ExploreHubApp.swift
//  ExploreHub
//
//  Created by Vitalii Kohut on 11.05.2023.
//

import SwiftUI

@main
struct ExploreHubApp: App {
//    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainNavigation()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
