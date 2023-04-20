//
//  Persistence.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/13/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    // Convenience
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    static var preview: PersistenceController = {

        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let release1 = Release(context: viewContext)
        release1.id = UUID(uuidString: "E07ABFD8-429B-4A5A-AEDB-EE4C9E9A7C94")!
        release1.releaseName = "Preview Release"
        
        let artist1 = Artist(context: viewContext)
        artist1.id = UUID(uuidString: "E07ABFD8-429B-4A5A-AEDB-EE4C9E9A7C95")!
        artist1.countFollowers = Int64(2222)
        artist1.dateRegistered = "artist.dateRegistered"
        artist1.dateRegisteredTS = Date(timeIntervalSince1970: 1672531200000)
        artist1.dateEditedTS = Date(timeIntervalSince1970: 1672531200000)
        artist1.descriptionShort = "artist.descriptionShort"
        artist1.isConfirmed = true
        artist1.mainImageName = "artist.mainImageName"
        artist1.mainImageURL = "artist.mainImageURL"
        artist1.name = "Artist Name From Persistance"

        try? viewContext.save()

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
