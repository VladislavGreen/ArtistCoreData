//
//  ProfileHostView.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/13/23.
//

import SwiftUI

struct ProfileHostView: View {
    
    @AppStorage("defaultArtist") var defaultArtist: String?
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.name)],
        animation: .default)
    private var artists: FetchedResults<Artist>
    
    
    var body: some View {
        VStack{
            
            Text("Managed artist:")
            
            Picker(selection: $defaultArtist, label: Text("Select an artist")) {
                if artists.count == 0 {
                    Text("No artist loaded").tag(nil as String?)
                }
                ForEach(artists) { artist in
                    Text(artist.name ?? "").tag(artist.name as String?)
                }
            }
        }
    }
}

struct ProfileHostView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHostView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

