//
//  Persistence.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/13/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let artists: [ArtistCodable] = JsonReader.shared.load("artistsData000.json")

        for artist in artists {
            let newArtist = Artist(context: viewContext)
            newArtist.id = artist.id
            newArtist.countFollowers = artist.countFollowers
            newArtist.dateRegistered = artist.dateRegistered
            newArtist.dateRegisteredTS = artist.dateRegisteredTS
            newArtist.descriptionShort = artist.descriptionShort
            newArtist.isConfirmed = artist.isConfirmed
            newArtist.mainImageName = artist.mainImageName
            newArtist.mainImageURL = artist.mainImageURL
            //        newArtist.name = artist.name
            newArtist.name = "Preview Artist \(artist.id) Name"
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ArtistCoreData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                print("❌ init error")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print("✅ init")
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
