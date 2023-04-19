//
//  ArtistCoreDataApp.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/13/23.
//

import SwiftUI

@main
struct ArtistCoreDataApp: App {
//    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, CoreDataManager.shared.context)
        }
        .onChange(of: scenePhase) { _ in
            CoreDataManager.shared.saveContext()
        }
    }
}
