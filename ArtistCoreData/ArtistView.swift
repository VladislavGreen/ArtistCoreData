//
//  ArtistView.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/13/23.
//  Способ динамического выбора предиката https://developer.apple.com/documentation/swiftui/fetchrequest/configuration


import SwiftUI
import CoreData

struct ArtistView: View {
    
    @AppStorage("defaultArtist") var defaultArtist = DefaultSettings.defaultArtistName
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name, order: .reverse)],
        animation: .default)
    private var artists: FetchedResults<Artist>
    
    @State private var showingProfile = false
    
    
    var body: some View {
        VStack {
            
            if artists.count != 0 {
                Text(artists.first?.name ?? "Неизвестный артист")
            } else {
                Text("Нет данных")
            }
            
            Button {
                showingProfile.toggle()
            } label: {
                Text("Profile (to change current artist)")
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHostView()
                    .environment(\.managedObjectContext, self.viewContext)
            }
        }
        .onChange(of: defaultArtist) { value in
            artists.nsPredicate = defaultArtist.isEmpty
            ? nil
            : NSPredicate(format: "name == %@", value)
        }
    }
}

// Пробуем задавать превью контент непосредственно:
struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.viewContext
        
        let release1 = Release(context: viewContext)
        release1.id = Int64(333)
        release1.releaseName = "Preview Release"
        
        let artist1 = Artist(context: viewContext)
        artist1.id = Int64(1111)
        artist1.countFollowers = Int64(2222)
        artist1.dateRegistered = "artist.dateRegistered"
        artist1.dateRegisteredTS = Int64(1672531200000)
        artist1.descriptionShort = "artist.descriptionShort"
        artist1.isConfirmed = true
        artist1.mainImageName = "artist.mainImageName"
        artist1.mainImageURL = "artist.mainImageURL"
        artist1.name = "Preview Artist Name 1"

        try? viewContext.save()
        
        return ArtistView()
            .environment(\.managedObjectContext, viewContext)
    }
}


