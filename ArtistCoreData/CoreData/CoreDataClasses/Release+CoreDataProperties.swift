//
//  Release+CoreDataProperties.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/17/23.
//
//

import Foundation
import CoreData


extension Release {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Release> {
        return NSFetchRequest<Release>(entityName: "Release")
    }

    @NSManaged public var id: Int64
    @NSManaged public var releaseName: String?
    @NSManaged public var ofArtist: Artist?

}

extension Release : Identifiable {

}

