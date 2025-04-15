//
//  AnimalTests.swift
//  SLAPUITests
//
//  Created by Jay Lyerly on 4/3/25.
//

import Foundation
import Testing

@testable import SLAPUI

@Suite("Animal Model Tests") struct AnimalTests {
    
    let singleJson: Data
    let animal: Animal
    
    init() throws {
        singleJson = try Data.jsonData(forFilePrefix: "animal")
        animal = try JSONDecoder().decode(Animal.self, from: singleJson)
    }
    
    @Test func parseAnimal() throws {
        // swiftlint:disable:next line_length
        let desc = "Meet Honey & Juniper! These two sisters are about 7 months old and must be adopted together. They may be small, but they need a lot of space to play and more importantly, to get away from each other when they want some alone time. They are currently living in a 10x11 bunny proofed room, but if they could talk, they would probably say they could use a little more square footage. They love to munch on hay all day long, but in the morning they circle like sharks for pellets. They also enjoy eating veggies twice a day. They are still pretty shy, but they will warm up to you if you give them time. They are also quite active and would prefer to run around than be pet. They make great bunny entertainment AKA bunny TV! Currently fostering in the Charlotte area."
        let photo1 = "https://www.shelterluv.com/sites/default/files/animal_pics/37724/2022/04/12/10/20220412103758.png"
        let photo2 = "https://www.shelterluv.com/sites/default/files/animal_pics/37724/2022/09/15/07/20220915072532.png"

        // Check raw values
        #expect(animal.internalId == "52423098")
        #expect(animal.name == "Honey")
        #expect(animal.rawSex == "Female")
        #expect(animal.status == "Healthy In Home")
        #expect(animal.rawWeight == "4.0962")
        #expect(animal.rawAltered == "Yes")
        #expect(animal.rawAge == 32)
        #expect(animal.rawCoverPhoto == photo1)
        #expect(animal.animalDescription == desc)
        #expect(animal.rawPhotos == [photo1, photo2])
        
        let url1 = try #require(URL(string: photo1))
        let url2 = try #require(URL(string: photo2))
        // Check derived values
        #expect(animal.sex == .female)
        #expect(aboutEqual(animal.weight, 4.0962))
        #expect(animal.altered)
        #expect(aboutEqual(animal.age, 2.66666))
        #expect(animal.coverPhoto == url1)
        #expect(animal.photos == [url1, url2])
    }
    
    @Test func roundTrip() throws {
        let internalId = "5555555555"
        let name = "Steve"
        let rawSex = "Male"
        let status = "Running Amok"
        let rawWeight = "5.1323"
        let rawAltered = "No"
        let rawAge = 55
        let rawCoverPhoto = "https://www.example.com/sites/default/files/animal_pics/3770.png"
        let rawPhotos = [
            "https://www.example.com/sites/default/files/animal_pics/3771.png",
            "https://www.example.com/sites/default/files/animal_pics/3772.png",
            "https://www.example.com/sites/default/files/animal_pics/3773.png",
        ]
        let animalDescription = "Up on the roof top."
        let isFavorite: Bool? = nil
        let isPublishable: Bool? = nil
        
        let animal = Animal(internalId: internalId,
                            name: name,
                            rawSex: rawSex,
                            status: status,
                            rawWeight: rawWeight,
                            rawAltered: rawAltered,
                            rawAge: rawAge,
                            rawCoverPhoto: rawCoverPhoto,
                            rawPhotos: rawPhotos,
                            animalDescription: animalDescription,
                            isFavorite: isFavorite,
                            isPublishable: isPublishable)
        
        let data = try JSONEncoder().encode(animal)
        let newAnimal = try JSONDecoder().decode(Animal.self, from: data)
        
        #expect(newAnimal.name == name)
        #expect(newAnimal.rawSex == rawSex)
        #expect(newAnimal.status == status)
        #expect(newAnimal.rawWeight == rawWeight)
        #expect(newAnimal.rawAltered == rawAltered)
        #expect(newAnimal.rawAge == rawAge)
        #expect(newAnimal.rawCoverPhoto == rawCoverPhoto)
        #expect(newAnimal.rawPhotos == rawPhotos)
        #expect(newAnimal.animalDescription == animalDescription)
        #expect(newAnimal.isFavorite == isFavorite)
        #expect(newAnimal.isPublishable == isPublishable)

    }
    
    // swiftlint:disable:next function_body_length
    @Test func checkMerge() throws {
        let animal1 = animal
        // swiftlint:disable:next line_length
        let desc = "Meet Honey & Juniper! These two sisters are about 7 months old and must be adopted together. They may be small, but they need a lot of space to play and more importantly, to get away from each other when they want some alone time. They are currently living in a 10x11 bunny proofed room, but if they could talk, they would probably say they could use a little more square footage. They love to munch on hay all day long, but in the morning they circle like sharks for pellets. They also enjoy eating veggies twice a day. They are still pretty shy, but they will warm up to you if you give them time. They are also quite active and would prefer to run around than be pet. They make great bunny entertainment AKA bunny TV! Currently fostering in the Charlotte area."
        let photo1 = "https://www.shelterluv.com/sites/default/files/animal_pics/37724/2022/04/12/10/20220412103758.png"
        let photo2 = "https://www.shelterluv.com/sites/default/files/animal_pics/37724/2022/09/15/07/20220915072532.png"

        // Check raw values
        #expect(animal1.internalId == "52423098")
        #expect(animal1.name == "Honey")
        #expect(animal1.rawSex == "Female")
        #expect(animal1.status == "Healthy In Home")
        #expect(animal1.rawWeight == "4.0962")
        #expect(animal1.rawAltered == "Yes")
        #expect(animal1.rawAge == 32)
        #expect(animal1.rawCoverPhoto == photo1)
        #expect(animal1.animalDescription == desc)
        #expect(animal1.rawPhotos == [photo1, photo2])
        
        let internalId = "5555555555"
        let name = "Steve"
        let rawSex = "Male"
        let status = "Running Amok"
        let rawWeight = "5.1323"
        let rawAltered = "No"
        let rawAge = 55
        let rawCoverPhoto = "https://www.example.com/sites/default/files/animal_pics/3770.png"
        let rawPhotos = [
            "https://www.example.com/sites/default/files/animal_pics/3771.png",
            "https://www.example.com/sites/default/files/animal_pics/3772.png",
            "https://www.example.com/sites/default/files/animal_pics/3773.png",
        ]
        let animalDescription = "Up on the roof top."
        let isFavorite: Bool? = nil
        let isPublishable: Bool? = nil
        
        let animal2 = Animal(internalId: internalId,
                             name: name,
                             rawSex: rawSex,
                             status: status,
                             rawWeight: rawWeight,
                             rawAltered: rawAltered,
                             rawAge: rawAge,
                             rawCoverPhoto: rawCoverPhoto,
                             rawPhotos: rawPhotos,
                             animalDescription: animalDescription,
                             isFavorite: isFavorite,
                             isPublishable: isPublishable)
        
        #expect(animal2.name == name)
        #expect(animal2.rawSex == rawSex)
        #expect(animal2.status == status)
        #expect(animal2.rawWeight == rawWeight)
        #expect(animal2.rawAltered == rawAltered)
        #expect(animal2.rawAge == rawAge)
        #expect(animal2.rawCoverPhoto == rawCoverPhoto)
        #expect(animal2.rawPhotos == rawPhotos)
        #expect(animal2.animalDescription == animalDescription)
        #expect(animal2.isFavorite == isFavorite)
        #expect(animal2.isPublishable == isPublishable)
        
        // Merge with an animal that has extra data
        animal1.merge(with: animal2)
        
        #expect(animal1.name == name)
        #expect(animal1.rawSex == rawSex)
        #expect(animal1.status == status)
        #expect(animal1.rawWeight == rawWeight)
        #expect(animal1.rawAltered == rawAltered)
        #expect(animal1.rawAge == rawAge)
        #expect(animal1.rawCoverPhoto == rawCoverPhoto)
        #expect(animal1.rawPhotos == rawPhotos)
        #expect(animal1.animalDescription == animalDescription)
        #expect(animal1.isFavorite == isFavorite)
        #expect(animal1.isPublishable == isPublishable)
        
        let animal3 = Animal(internalId: "5555555555", name: "Bob")
        // Merge with animal that has no extra data
        animal1.merge(with: animal3)
        
        #expect(animal1.name == "Bob")
        #expect(animal1.rawSex == rawSex)
        #expect(animal1.status == status)
        #expect(animal1.rawWeight == rawWeight)
        #expect(animal1.rawAltered == rawAltered)
        #expect(animal1.rawAge == rawAge)
        #expect(animal1.rawCoverPhoto == rawCoverPhoto)
        #expect(animal1.rawPhotos == rawPhotos)
        #expect(animal1.animalDescription == animalDescription)
        #expect(animal1.isFavorite == isFavorite)
        #expect(animal1.isPublishable == isPublishable)
    }
    
}
