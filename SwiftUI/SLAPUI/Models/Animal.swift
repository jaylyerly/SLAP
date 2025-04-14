//
//  Animal.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/3/25.
//

import Foundation
import SwiftData

@Model
class Animal: Codable {

    // Disable check for '_' in id name b/c we must match what the @Model macro generates
    // swiftlint:disable identifier_name
    enum CodingKeys: String, CodingKey {
        case _internalId = "Internal-ID"
        case _name = "Name"
        case _rawSex = "Sex"
        case _status = "Status"
        case _rawWeight = "CurrentWeightPounds"
        case _rawAltered = "Altered"
        case _rawAge = "Age"
        case _rawCoverPhoto = "CoverPhoto"
        case _rawPhotos = "Photos"
        case _animalDescription = "Description"
    }
    // swiftlint:enable identifier_name

    @Attribute(.unique)
    var internalId: String
    var name: String
    var rawSex: String?
    var status: String?
    var rawWeight: String?
    var rawAltered: String?
    var rawAge: Int?
    var rawCoverPhoto: String?
    var rawPhotos: [String]?
    var animalDescription: String?
    var isFavorite: Bool?
    var isPublishable: Bool?
        
    var id: String { internalId }

    init(
        internalId: String,
        name: String,
        rawSex: String? = nil,
        status: String? = nil,
        rawWeight: String? = nil,
        rawAltered: String? = nil,
        rawAge: Int? = nil,
        rawCoverPhoto: String? = nil,
        rawPhotos: [String]? = nil,
        animalDescription: String? = nil,
        isFavorite: Bool? = nil,
        isPublishable: Bool? = nil
    ) {
        self.internalId = internalId
        self.name = name
        self.rawSex = rawSex
        self.status = status
        self.rawWeight = rawWeight
        self.rawAltered = rawAltered
        self.rawAge = rawAge
        self.rawCoverPhoto = rawCoverPhoto
        self.rawPhotos = rawPhotos
        self.animalDescription = animalDescription
        self.isFavorite = isFavorite
        self.isPublishable = isPublishable
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        internalId = try container.decode(String.self, forKey: ._internalId)
        name = try container.decode(String.self, forKey: ._name)
        rawSex = try container.decodeIfPresent(String.self, forKey: ._rawSex)
        status = try container.decodeIfPresent(String.self, forKey: ._status)
        rawWeight = try container.decodeIfPresent(String.self, forKey: ._rawWeight)
        rawAltered = try container.decodeIfPresent(String.self, forKey: ._rawAltered)
        rawAge = try container.decodeIfPresent(Int.self, forKey: ._rawAge)
        rawCoverPhoto = try container.decodeIfPresent(String.self, forKey: ._rawCoverPhoto)
        rawPhotos = try container.decodeIfPresent([String].self, forKey: ._rawPhotos)
        animalDescription = try container.decodeIfPresent(String.self, forKey: ._animalDescription)
        isFavorite = nil
        isPublishable = nil
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(internalId, forKey: ._internalId)
        try container.encode(name, forKey: ._name)
        try container.encodeIfPresent(rawSex, forKey: ._rawSex)
        try container.encodeIfPresent(status, forKey: ._status)
        try container.encodeIfPresent(rawWeight, forKey: ._rawWeight)
        try container.encodeIfPresent(rawAltered, forKey: ._rawAltered)
        try container.encodeIfPresent(rawAge, forKey: ._rawAge)
        try container.encodeIfPresent(rawCoverPhoto, forKey: ._rawCoverPhoto)
        try container.encodeIfPresent(rawPhotos, forKey: ._rawPhotos)
        try container.encodeIfPresent(animalDescription, forKey: ._animalDescription)   
    }
}

extension Animal {
    // Synthetic properties
    var sex: Sex { Sex(str: rawSex) }
    
    var weight: Double? {
        guard let rawWeight, let doubleWeight = Double(rawWeight) else { return nil }
        return doubleWeight
    }
    
    var altered: Bool {
        guard let rawAltered else { return false }
        return rawAltered.lowercased().starts(with: "y")    // Yes or No
    }
    
    var age: Double? {
        guard let rawAge else { return nil }
        // rawAge is in months, so convert to years
        return Double(rawAge) / 12.0
    }
    
    var coverPhoto: URL? {
        guard let rawCoverPhoto else { return nil }
        return URL(string: rawCoverPhoto)
    }
    
    var photos: [URL] {
        (rawPhotos ?? []).compactMap { URL(string: $0) }
    }
}

// MARK: CRUD helpers

extension Animal {
    func merge(with other: Animal) {
        name = other.name
        rawSex = other.rawSex ?? rawSex
        status = other.status ?? status
        rawWeight = other.rawWeight ?? rawWeight
        rawAltered = other.rawAltered ?? rawAltered
        rawAge = other.rawAge ?? rawAge
        rawCoverPhoto = other.rawCoverPhoto ?? rawCoverPhoto
        rawPhotos = other.rawPhotos ?? rawPhotos
        animalDescription = other.animalDescription ?? animalDescription
        isFavorite = other.isFavorite ?? isFavorite
        isPublishable = other.isPublishable ?? isPublishable
    }
}

// MARK: - Preview Data -

extension Animal {
    
    static var previewAnimals: [Animal] {
        guard let url = Bundle.main.url(forResource: "animals.publishable", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let wrapper = try? JSONDecoder().decode(AnimalWrapper.self, from: data) else {
            return []
        }

        return wrapper.animals
    }
    
    static let previewAnimal = previewAnimals[0] 
}
