//
//  CoreDataHelpers.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/17/23.
//


extension CodingUserInfoKey {
    static let contextUserInfoKey = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum ContextError: Error {
    case NoContextFound
}
