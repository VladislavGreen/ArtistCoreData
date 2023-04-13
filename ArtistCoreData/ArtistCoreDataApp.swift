//
//  ArtistCoreDataApp.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/13/23.
//

import SwiftUI

@main
struct ArtistCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
