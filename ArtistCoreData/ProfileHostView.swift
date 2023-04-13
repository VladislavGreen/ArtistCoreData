//
//  ProfileHostView.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/13/23.
//

import SwiftUI

struct ProfileHostView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var artists: FetchedResults<Artist>
    
    var body: some View {
        VStack{
            
            Text("Managed artists:")
            
                List {
                    ForEach(artists) { artist in
                        HStack {
                            Text(artist.name ?? "")
                            Button {
                                // makeDefaultArtist
                                
                            } label: {
                                Text("Default")
                            }
                        }
                        .onTapGesture {
                            print(artist.objectID)
                            print(type(of: artist.objectID)) //NSCoreDataTaggedObjectID
                        }
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
