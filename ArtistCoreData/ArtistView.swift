//
//  ArtistView.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/13/23.
//

import SwiftUI
import CoreData

struct ArtistView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var artists: FetchedResults<Artist>
    
    @State private var showingProfile = false
    
    @Binding var artistIndex: Int
    init(artistIndex: Binding<Int> = .constant(0)) {
        _artistIndex = artistIndex
    }
    
    
    var body: some View {
        VStack {
            Text("С превью мы справились:")
            if artists.count != 0 {
                Text(artists[artistIndex].name ?? "Нет данных")
            } else {
                Text("Данные не загружаются")
            }
            Button {
                showingProfile.toggle()
            } label: {
                Text("Profile")
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHostView()
                    .environment(\.managedObjectContext, self.viewContext)
            }
        }
    }
}

struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
