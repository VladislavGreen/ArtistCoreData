//
//  ArtistView.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/13/23.
//  Способ динамического выбора предиката https://developer.apple.com/documentation/swiftui/fetchrequest/configuration


import SwiftUI
import CoreData

struct ArtistView: View {
    
    @AppStorage("defaultArtistName") var defaultArtistName: String?
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name, order: .reverse)],
        animation: .default)
    private var artists: FetchedResults<Artist>
    
    @State private var showingProfile = false
    @State private var showingEditor = false
    @State private var isNewArtist: Bool = true
    @State private var isDeleteAlert = false
    
    var body: some View {
        VStack {
            
            if artists.count != 0 {
                Text(artists.first?.name ?? "Неизвестный артист")
                    .onAppear {
                        getDefaultArtist()
                    }
            } else {
                Text("Нет данных")
            }
            
            Button {
                showingProfile.toggle()
            } label: {
                Text("CHOOSE current artist)")
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHostView()
                    .environment(\.managedObjectContext, self.viewContext)
            }
            
            Button {
                showingEditor.toggle()
                isNewArtist = false
            } label: {
                Text("EDIT current artist)")
            }
            .disabled(artists.count == 0)
            .sheet(isPresented: $showingEditor) {
                ArtistEditorView(isNewArtist: $isNewArtist)
                .environment(\.managedObjectContext, self.viewContext)
            }
            
            Button {
                showingEditor.toggle()
                isNewArtist = true
            } label: {
                Text("CREATE NEW artist)")
            }
            .sheet(isPresented: $showingEditor) {
                ArtistEditorView(isNewArtist: $isNewArtist)
                .environment(\.managedObjectContext, self.viewContext)
            }
            
            Button {
                isDeleteAlert = true
            } label: {
                Text("DELETE current artist)")
            }
            .disabled(artists.count == 0)
        }
        .onChange(of: defaultArtistName ?? "Непредвиденное") { value in
            artists.nsPredicate = defaultArtistName?.isEmpty ?? true
            ? nil
            : NSPredicate(format: "name == %@", value)
        }
        .alert(isPresented: $isDeleteAlert) {
            Alert(
                title: Text("Alert"),
                message: Text("Вы уверены?"),
                primaryButton: .destructive(Text("Delete")) {
                    
                    CoreDataManager.shared.deleteArtist(artists.first!) {
                        defaultArtistName = nil
                        getDefaultArtist()
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func getDefaultArtist() {
        
        if artists.count  != 0 {
            for artist in artists {
                if artist.name != nil {
                    defaultArtistName = artist.name
                    print("❇️ \(defaultArtistName)")
                    break
                }
            }
        } else {
            print("artists.count = 0 ")
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


