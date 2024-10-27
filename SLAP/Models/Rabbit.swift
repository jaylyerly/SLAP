//
//  Rabbit.swift
//  SLAP
//
//  Created by Jay Lyerly on 10/26/24.
//

import Foundation
import SwiftData

@Model
class Rabbit: Codable {
    enum CodingKeys: String, CodingKey {
        case internalId = "Internal-ID"
        case name = "Name"
        case rawSex = "Sex"
        case status = "Status"
        case rawWeight = "CurrentWeightPounds"
        case rawAltered = "Altered"
        case rawAge = "Age"
        case rawCoverPhoto = "CoverPhoto"
        case rawPhotos = "Photos"
        case rabbitDescription = "Description"
    }

    var internalId: String
    var name: String
    var rawSex: String?
    var status: String?
    var rawWeight: String?
    var rawAltered: String?
    var rawAge: Int?
    var rawCoverPhoto: String?
    var rawPhotos: [String]?
    var rabbitDescription: String?

    var sex: RabbitSex { RabbitSex(str: rawSex) }
    var weight: Int? {
        guard let rawWeight, let doubleWeight = Double(rawWeight) else { return nil }
        return Int(floor(doubleWeight))
    }
    var altered: Bool {
        guard let rawAltered else { return false }
        return rawAltered.lowercased().starts(with: "y")    // Yes or No
    }
    var age: Int? {
        guard let rawAge else { return nil }
        // rawAge is in months, so convert to years
        return rawAge / 12
    }
    var coverPhoto: URL? {
        guard let rawCoverPhoto else { return nil }
        return URL(string: rawCoverPhoto)
    }
    var photos: [URL] {
        (rawPhotos ?? []).compactMap { URL(string: $0) }
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        internalId = try container.decode(String.self, forKey: .internalId)
        name = try container.decode(String.self, forKey: .name)
        rawSex = try container.decode(String.self, forKey: .rawSex)
        status = try container.decode(String.self, forKey: .status)
        rawWeight = try container.decode(String.self, forKey: .rawWeight)
        rawAltered = try container.decode(String.self, forKey: .rawAltered)
        rawAge = try container.decode(Int.self, forKey: .rawAge)
        rawCoverPhoto = try container.decode(String.self, forKey: .rawCoverPhoto)
        rawPhotos = try container.decode([String].self, forKey: .rawPhotos)
        rabbitDescription = try container.decode(String.self, forKey: .rabbitDescription)
        internalId = try container.decode(String.self, forKey: .internalId)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .internalId)
        try container.encode(name, forKey: .name)
        try container.encode(name, forKey: .rawSex)
        try container.encode(name, forKey: .status)
        try container.encode(name, forKey: .rawWeight)
        try container.encode(name, forKey: .rawAltered)
        try container.encode(name, forKey: .rawAge)
        try container.encode(name, forKey: .rawCoverPhoto)
        try container.encode(name, forKey: .rawPhotos)
        try container.encode(name, forKey: .rabbitDescription)
    }
}

extension Rabbit: Identifiable {
    
    var id: String { internalId }
    
}

extension Rabbit: CustomDebugStringConvertible {
    
    var debugDescription: String {
        "Rabbit<\(Unmanaged.passUnretained(self).toOpaque())>: \(name) (\(id))"
    }
    
}
