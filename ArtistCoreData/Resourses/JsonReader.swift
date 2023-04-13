//
//  JsonReader.swift
//  ArtistCoreData
//
//  Created by Vladislav Green on 4/13/23.
//

import Foundation
import Combine

class JsonReader {
    
    public static let shared = JsonReader()
    
    // метод загрузки локального (демо) JSON
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            print("Couldn't find \(filename) in main bundle.")
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            print("Couldn't find \(filename) in main bundle.")
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Couldn't find \(filename) in main bundle.")
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    // Альтернатива:
    // Выборка данных Модели <T> из файла в Bundle
    func fetch<T: Decodable>(_ nameJSON: String) -> AnyPublisher<T, Error> {
        Just (nameJSON)
        .flatMap { (nameJSON) -> AnyPublisher<Data, Never> in
            let path = Bundle.main.path(forResource:nameJSON, ofType: "json")!
            let data = FileManager.default.contents(atPath: path)!
            print("✅ fetch")
            return Just(data)
            .eraseToAnyPublisher()
        }
        .decode(type: T.self, decoder: jsonDecoder)
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
       
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }()
    
    private var subscriptions = Set<AnyCancellable>()
       
    deinit {
        for cancell in subscriptions {
            cancell.cancel()
        }
    }
    
    
    // Попробуем без дженериков
    func readJSON(_ filename: String, completion: (_ artistCodable: [ArtistCodable]?, _ errorString: String?) -> Void) {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            print("Couldn't find \(filename) in main bundle.")
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            print("Couldn't find \(filename) in main bundle.")
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let artists = try decoder.decode([ArtistCodable].self, from: data)
            completion(artists, nil)
        } catch let error {
            print(error)
            print("Ошибка докодирования JSON")
            completion(nil, error.localizedDescription)
        }
    }
}
