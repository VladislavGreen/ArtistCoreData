//
//  Release+CoreDataClass.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/17/23.
//
//

import Foundation
import CoreData

@objc(Release)
public class Release: NSManagedObject, Codable {
    required convenience public init(from decoder: Decoder) throws {
        // Сначала, получаем контекст
        guard let context = decoder.userInfo[.contextUserInfoKey] as? NSManagedObjectContext else {
            throw ContextError.NoContextFound
        }
        self.init(context: context)
        
        // Декодируем
        let values = try decoder.container(keyedBy: ReleaseCodingKeys.self)
        id = try values.decode(Int64.self, forKey: .id)
        releaseName = try values.decode(String.self, forKey: .releaseName)
//        ofArtist = try values.decode(Artist.self, forKey: .ofArtist)
    }
    
    // Confirming Encoding
    public func encode(to encoder: Encoder) throws {
        // Encoding Item
        var values = encoder.container(keyedBy: ReleaseCodingKeys.self)
        try values.encode(id, forKey: .id)
        try values.encode(releaseName, forKey: .releaseName)
//        try values.encode(ofArtist, forKey: .ofArtist)
    }
    
    enum ReleaseCodingKeys: CodingKey {
        case id, releaseName
//        , ofArtist
    }
}

