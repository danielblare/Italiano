//
//  JSONDecoder.swift
//  Italiano
//
//  Created by Daniel on 10/7/23.
//

import Foundation

extension JSONDecoder {
    
    /// Decodes type from JSON file in Bundle.main
    static func decode<T: Decodable>(from file: String, type: T.Type) throws -> T {
        guard let url = Bundle.main.url(forResource: file, withExtension: "json") else { throw URLError(.fileDoesNotExist) }
        let data = try Data(contentsOf: url)
        let result = try JSONDecoder().decode(T.self, from: data)
        return result
    }
}
