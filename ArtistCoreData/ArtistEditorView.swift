//
//  ArtistEditorView.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/18/23.
//

import SwiftUI

struct ArtistEditorView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name)],
        animation: .default)
    private var artists: FetchedResults<Artist>
    
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("defaultArtistName") var defaultArtistName: String?
    
    @State var descriptionShort: String = ""
    @State var mainImageURL: String = ""
    @State var name: String = ""
    
    @State private var isAlert = false
    
    @Binding var isNewArtist: Bool
    
    var body: some View {
        
        Form {
            Section {
                TextField("Enter first name", text: $name)
                .disableAutocorrection(true)
                TextField("Brief description", text: $descriptionShort)
                .disableAutocorrection(true)
                TextField("Enter Artist image URL", text: $mainImageURL)
                .disableAutocorrection(true)
               }
            Button (isNewArtist ? "Add Artist" : "Confirm changes") {
                if self.name == "" {
                    self.isAlert = true
                    return
                }
                
                let artist = isNewArtist
                ? Artist(context: viewContext)
                : artists.first
                artist?.name = self.name
                artist?.descriptionShort = self.descriptionShort
                artist?.mainImageURL = self.mainImageURL
                
                CoreDataManager.shared.saveContext()
//                try? self.viewContext.save()
                
                defaultArtistName = self.name
                
                self.presentationMode.wrappedValue.dismiss()
            }
            .alert(isPresented: $isAlert) { () -> Alert in
                Alert(title: Text("Alert"), message: Text("No text field should be empty"), dismissButton: .default(Text("Ok")))
            }
        }
        .onAppear {
            print(isNewArtist)
            if isNewArtist {
                descriptionShort = ""
                mainImageURL = ""
                name = ""
            } else {
                artists.nsPredicate = defaultArtistName?.isEmpty ?? true
                ? nil
                : NSPredicate(format: "name == %@", defaultArtistName!)
                
                descriptionShort = artists.first?.descriptionShort ?? ""
                mainImageURL = artists.first?.mainImageURL ?? ""
                name = artists.first?.name ?? ""
            }
        }
    }
}

struct ArtistEditorView_Previews: PreviewProvider {
    static var previews: some View {
//        ArtistEditorView()
        
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

        return ArtistEditorView(isNewArtist: .constant(true))
            .environment(\.managedObjectContext, viewContext)
    }
}

