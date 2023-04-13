//
//  Artist.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/13/23.
//

import Foundation

struct ArtistCodable: Hashable, Codable, Identifiable {
    var id: Int64
    var name: String
    var dateRegistered: String
    var dateRegisteredTS: Int64
    var isConfirmed: Bool
    var descriptionShort: String
    var countFollowers: Int64
    var mainImageName: String
    var mainImageURL: String
}
