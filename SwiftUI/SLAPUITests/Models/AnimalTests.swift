//
//  AnimalTests.swift
//  SLAPUI
//
//  Created by Jay Lyerly on 4/3/25.
//

import Foundation
import Testing

@testable import SLAPUI

@Suite("Animal Model Tests") struct AnimalModelTests {
    
    let singleJson: Data
    let animal: Animal
    
    init() throws {
        singleJson = try Data.jsonData(forFilePrefix: "animal")
        animal = try JSONDecoder().decode(Animal.self, from: singleJson)
    }
    
    @Test func parseAnimal() throws {        
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
        #expect(aboutEqual(try #require(animal.weight), 4.0962))
        #expect(animal.altered)
        #expect(aboutEqual(try #require(animal.age), 2.66666))
        #expect(animal.coverPhoto == url1)
        #expect(animal.photos == [url1, url2])
    }
    
}
