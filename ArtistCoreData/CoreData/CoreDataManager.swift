//
//  CoreDataManager.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/13/23.
//  https://www.youtube.com/watch?v=0vByJw0aLAU

import Foundation
import CoreData


class CoreDataManager {
    
    var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    static let shared = CoreDataManager()
    private init(){}
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func importJson(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            print("Couldn't find \(filename) in main bundle.")
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        do {
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.userInfo[.contextUserInfoKey] = context
            decoder.dateDecodingStrategy = .millisecondsSince1970
            let artistsImported = try decoder.decode([Artist].self, from: jsonData)
            print("♻️ Обновляем CoreData из JSON")
            checkDuplicates(artistsImported)
        } catch {
            print("Что-то пошло не так")
            print(error)
        }
    }
    
    func checkDuplicates(_ artists: [Artist]) {

        // Проверка нет-ли уже такой сущности (по ID)

        for i in 0..<artists.count {
            let fetchRequestCheck = Artist.fetchRequest()
            fetchRequestCheck.predicate = NSPredicate(format: "id == %@", artists[i].id as CVarArg)
            let results = try? context.fetch(fetchRequestCheck)
            guard results?.first != nil else {
                print("\(String(describing: results?.first?.name)) Imported successfully")
                return
            }
            if results!.count > 1 {
                let result = results?.first
                // ⭕️ хорошо бы сделать проверку по дате последней редакции timestamp
                print("\(String(describing: artists[i].name)) уже есть удаляем дубликат")
                deleteArtist(result!)
            }
            
        }
    }
    
    func deleteArtist(_ artist: Artist, completion: (()->(Void))? = nil) {
        print("❌ deleteArtist \(String(describing: artist.name))")
        context.delete(artist)
        saveContext()
        completion?()
    }
    
    func clearDatabase() {
        let fetchRequest = Artist.fetchRequest()
        for artist in (try? context.fetch(fetchRequest)) ?? [] {
            deleteArtist(artist)
        }
        print("❌ Всё удалено")
    }
    
    func exportCoreData() {
        do {
            // 1 Fetching
            if let entityName = Artist.entity().name {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let items = try context.fetch(request).compactMap {
                    $0 as? Artist
                    // Здесь можно будет использовать предикаты (если данных много) и отображать прогресс
                }
                
                // 2 Конвертируем в JSON
                let jsonData = try JSONEncoder().encode(items)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("✅ Данные после конвертации в JSON:  \(jsonString)")
                    
                    // 3 Сохраняем пока в Temporary Document
                    if let tempURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        
                        let pathURL = tempURL.appending(
                            component: "Export\(Date().formatted(date: .complete, time: .omitted)).json")
                        try jsonString.write(to: pathURL, atomically: true, encoding: .utf8)
                        // Успешное сохранение
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}


// Далее, закомментированный код, который я пока хотел-бы оставить для справки

// остатки примера
// После успешного сохранения
//                        // Успешное сохранение
//                        shareURL = pathURL
//                        presentShareSheet.toggle()
//
//                        /*
//                         There is no way to present it like a sheet via native ShareLink (instead it's in the form of a button. That's the reason we use UIKit share Sheet
//                         */
//                        struct CustomShareSheet: UIViewControllerRepresentable {
//                            @Binding var url: URL
//
//                            func makeUIviewController(context: Context) -> UIActivityViewController {
//                                return UIActivityViewController(activityItems: [url], applicationActivities: nil)
//                            }
//
//                            func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
//
//                            }
//                        }

//    .sheet(isPresented: $presentShareSheet) {
//         // after the sheet is dismissed we're clearing up the temporary URL we creaded to save JSON file
//        deleteTempFile()
//    } content: {
//        CustomShareSheet(url: $shareURL)
//    }
//
//func deleteTempFile() {
//    do {
//        try FileManager.default.removeItem(at: shareURL)
//        print("Removed Temp JSON file")
//    } catch {
//        print(error.localizedDescription)
//    }
//}


//  Прошлые реализации

//    var artistsCodable: [ArtistCodable] = []
    
//    private var cancellableSet: Set<AnyCancellable> = []
    
//    func getArtists() {
//        print("✅ getArtists")
//
//        JsonReader.shared.readJSON("artistsData001.json") { artists, errorString in
//            if let artists {
//                for artist in artists {
//                    update(artist: artist, context: context)
//                }
//            }
//        }
//    }
//
//    private func update(artist: ArtistCodable, context: NSManagedObjectContext) {
//        print("✅ update")
//
//        let newArtist: Artist!
//
//        // Проверка нет-ли уже такой сущности (по ID)
//        let fetchRequestCheck = Artist.fetchRequest()
//        fetchRequestCheck.predicate = NSPredicate(format: "id == %i", artist.id)
//
//        let results = try? context.fetch(fetchRequestCheck)
//        if results?.count != 0 {
//            // если есть
//            newArtist = results?.first  // и потом меняем значения
//            print("данные для объекта \(String(describing: newArtist.name)) были обновлены")
//        } else {
//            newArtist = Artist(context: context)
//        }
//
//        newArtist.id = artist.id
//        newArtist.countFollowers = artist.countFollowers
//        newArtist.dateRegistered = artist.dateRegistered
//        newArtist.dateRegisteredTS = artist.dateRegisteredTS
//        newArtist.descriptionShort = artist.descriptionShort
//        newArtist.isConfirmed = artist.isConfirmed
//        newArtist.mainImageName = artist.mainImageName
//        newArtist.mainImageURL = artist.mainImageURL
//        newArtist.name = artist.name
//
//        var newReleases: [Release] = []
//        for release in artist.releases {
//            let newRelease = Release(context: context)
//            newRelease.id = release.id
//            newRelease.releaseName = release.releaseName
//
//            newReleases.append(newRelease)
//        }
//        newArtist.releases = Set(newReleases)
//
//        do {
//            try context.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }

