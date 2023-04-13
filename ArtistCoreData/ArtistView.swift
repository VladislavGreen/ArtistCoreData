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
    
    
    var body: some View {
        VStack {
            Text("С превью мы справились:")
            if let artists {
                Text(artists.first?.name ?? "Нет данных")
            } else {
                Text("Данные не загружаются")
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
