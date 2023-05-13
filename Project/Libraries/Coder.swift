//
//  Coder.swift
//  Project
//
//  Created by Алексей Степанов on 2023-05-01.
//

import Foundation

func decodeFromJSON<T: Decodable>(_ jsonString: String, to type: T.Type) -> T? {
    guard let jsonData = jsonString.data(using: .utf8) else {
        return nil
    }

    do {
        let decodedData = try JSONDecoder().decode(type, from: jsonData)
        return decodedData
    } catch let error {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

func encodeToJSON(_ value: Encodable) -> String? {
    let encoder = JSONEncoder()

    do {
        let jsonData = try encoder.encode(value)
        let jsonString = String(data: jsonData, encoding: .utf8)
        return jsonString
    } catch let error {
        print("Error encoding JSON: \(error)")
        return nil
    }
}

