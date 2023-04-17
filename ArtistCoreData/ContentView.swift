//
//  ContentView.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/13/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var timeRemaining = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Spacer()
            ArtistView()
            Spacer()
            
            Button {
                refreshData()
            } label: {
                Text("Load default JSON to CoreData")
            }
            
            Button {
                printDataBaseAsJson()
            } label: {
                Text("Print current database as JSON")
            }
            
            Button {
                let coreDataManager = CoreDataManager()
                coreDataManager.clearDatabase()
            } label: {
                Text("Clear Database")
            }
            
            Spacer()
        }
        .onReceive(timer) {_ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
            if timeRemaining == 0 {
                print("Start")
                refreshData()
                self.timer.upstream.connect().cancel()
            }
        }
    }
    
    private func refreshData() {
        let coreDataManager = CoreDataManager()
        coreDataManager.importJson(filename: "artistsData001.json")
    }
    
    private func printDataBaseAsJson() {
        let coreDataManager = CoreDataManager()
        coreDataManager.exportCoreData()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
