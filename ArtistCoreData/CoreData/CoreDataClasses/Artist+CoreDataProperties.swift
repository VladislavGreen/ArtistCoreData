//
//  Artist+CoreDataProperties.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/16/23.
//
//

import Foundation
import CoreData


extension Artist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artist> {
        return NSFetchRequest<Artist>(entityName: "Artist")
    }

    @NSManaged public var countFollowers: Int64
    @NSManaged public var dateRegistered: String?
    @NSManaged public var dateRegisteredTS: Date
    @NSManaged public var dateEditedTS: Date
    @NSManaged public var descriptionShort: String?
    @NSManaged public var id: UUID
    @NSManaged public var isConfirmed: Bool
    @NSManaged public var mainImageName: String?
    @NSManaged public var mainImageURL: String?
    @NSManaged public var name: String?
    @NSManaged public var releases: Set<Release>

}

extension Artist : Identifiable {
}


