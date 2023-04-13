//
//  CoreDataManager.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/13/23.
//

import Foundation
import Combine
import CoreData


final class CoreDataManager {
    
    var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    var artistsCodable: [ArtistCodable] = []
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func getArtists() {
        print("✅ getArtists")
        
        JsonReader.shared.readJSON("artistsData000.json") { artists, errorString in
            if let artists {
                for artist in artists {
                    update(artist: artist, context: context)
                }
            }
        }
    }
    
    private func update(artist: ArtistCodable, context: NSManagedObjectContext) {
        print("✅ update")
        
        let newArtist = Artist(context: context)
        newArtist.id = artist.id
        newArtist.countFollowers = artist.countFollowers
        newArtist.dateRegistered = artist.dateRegistered
        newArtist.dateRegisteredTS = artist.dateRegisteredTS
        newArtist.descriptionShort = artist.descriptionShort
        newArtist.isConfirmed = artist.isConfirmed
        newArtist.mainImageName = artist.mainImageName
        newArtist.mainImageURL = artist.mainImageURL
        newArtist.name = artist.name
        
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func clearDatabase() {
        let fetchRequest = Artist.fetchRequest()
        for artist in (try? context.fetch(fetchRequest)) ?? [] {
            context.delete(artist)
        }
    }
}

