//
//  Artist+CoreDataClass.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/16/23.
//
//

import Foundation
import CoreData

@objc(Artist)
public class Artist: NSManagedObject, Codable {
    required convenience public init(from decoder: Decoder) throws {
        // Сначала, получаем контекст
        guard let context = decoder.userInfo[.contextUserInfoKey] as? NSManagedObjectContext else {
            throw ContextError.NoContextFound
        }
        self.init(context: context)
        
        // Декодируем
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int64.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        dateRegistered = try values.decode(String.self, forKey: .dateRegistered)
        dateRegisteredTS = try values.decode(Int64.self, forKey: .dateRegisteredTS)
        isConfirmed = try values.decode(Bool.self, forKey: .isConfirmed)
        descriptionShort = try values.decode(String.self, forKey: .descriptionShort)
        countFollowers = try values.decode(Int64.self, forKey: .countFollowers)
        mainImageName = try values.decode(String.self, forKey: .mainImageName)
        mainImageURL = try values.decode(String.self, forKey: .mainImageURL)
//        if let releasesArray = releases?.allObjects as? [Release] {
            releases = try values.decode(Set<Release>.self, forKey: .releases)
//        }
    }
    
    // Confirming Encoding
    public func encode(to encoder: Encoder) throws {
        // Encoding Item
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(id, forKey: .id)
        try values.encode(name, forKey: .name)
        try values.encode(dateRegistered, forKey: .dateRegistered)
        try values.encode(dateRegisteredTS, forKey: .dateRegisteredTS)
        try values.encode(isConfirmed, forKey: .isConfirmed)
        try values.encode(descriptionShort, forKey: .descriptionShort)
        try values.encode(countFollowers, forKey: .countFollowers)
        try values.encode(mainImageName, forKey: .mainImageName)
        try values.encode(mainImageURL, forKey: .mainImageURL)
        try values.encode(releases, forKey: .releases)
    }
    
    enum CodingKeys: CodingKey {
        case id,
             name,
             dateRegistered,
             dateRegisteredTS,
             isConfirmed,
             descriptionShort,
             countFollowers,
             mainImageName,
             mainImageURL,
             releases
    }
}








