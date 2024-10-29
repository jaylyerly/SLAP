//
//  RabbitTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/28/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

class RabbitTests: TestCase {
    
    var storage: Storage!
    
    override func setUpWithError() throws {
        storage = FakeStorage()
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        storage = nil
        try super.tearDownWithError()
    }
    
    func testModelConfig() throws {  // swiftlint:disable:this function_body_length
        let mom = storage.persistentContainer.managedObjectModel
        let entities = mom.entitiesByName
        let entity = try XCTUnwrap(entities["Rabbit"])
        
        let attrs = entity.attributesByName.map { $0.key }
        let expectedAttrKeys = Set([
            "age",
            "altered",
            "internalId",
            "isFavorite",
            "name",
            "rabbitDescription",
            "sex",
            "weight",
        ])
        expectNoDifference(Set(attrs), expectedAttrKeys)
        
        let notes = try XCTUnwrap(entity.attributesByName["age"])
        XCTAssertEqual(notes.attributeType, .floatAttributeType)
        XCTAssertEqual(notes.defaultValue as? Float, 0)
        XCTAssertTrue(notes.isOptional)
        XCTAssertEqual(notes.validationPredicates.map { "\($0)" }, [])

        let altered = try XCTUnwrap(entity.attributesByName["altered"])
        XCTAssertEqual(altered.attributeType, .booleanAttributeType)
        XCTAssertNil(altered.defaultValue)
        XCTAssertTrue(altered.isOptional)
        XCTAssertEqual(altered.validationPredicates.map { "\($0)" }, [])

        let internalId = try XCTUnwrap(entity.attributesByName["internalId"])
        XCTAssertEqual(internalId.attributeType, .stringAttributeType)
        XCTAssertNil(internalId.defaultValue)
        XCTAssertFalse(internalId.isOptional)
        XCTAssertEqual(internalId.validationPredicates.map { "\($0)" }, [])

        let isFavorite = try XCTUnwrap(entity.attributesByName["isFavorite"])
        XCTAssertEqual(isFavorite.attributeType, .booleanAttributeType)
        XCTAssertEqual(isFavorite.defaultValue as? Bool, false)
        XCTAssertFalse(isFavorite.isOptional)
        XCTAssertEqual(isFavorite.validationPredicates.map { "\($0)" }, [])

        let name = try XCTUnwrap(entity.attributesByName["name"])
        XCTAssertEqual(name.attributeType, .stringAttributeType)
        XCTAssertNil(name.defaultValue)
        XCTAssertTrue(name.isOptional)
        XCTAssertEqual(name.validationPredicates.map { "\($0)" }, [])

        let rabbitDescription = try XCTUnwrap(entity.attributesByName["rabbitDescription"])
        XCTAssertEqual(rabbitDescription.attributeType, .stringAttributeType)
        XCTAssertNil(rabbitDescription.defaultValue)
        XCTAssertTrue(rabbitDescription.isOptional)
        XCTAssertEqual(rabbitDescription.validationPredicates.map { "\($0)" }, [])

        let sex = try XCTUnwrap(entity.attributesByName["sex"])
        XCTAssertEqual(sex.attributeType, .stringAttributeType)
        XCTAssertNil(sex.defaultValue)
        XCTAssertTrue(sex.isOptional)
        XCTAssertEqual(sex.validationPredicates.map { "\($0)" }, [])

        let weight = try XCTUnwrap(entity.attributesByName["weight"])
        XCTAssertEqual(weight.attributeType, .floatAttributeType)
        XCTAssertEqual(weight.defaultValue as? Float, 0)
        XCTAssertTrue(weight.isOptional)
        XCTAssertEqual(weight.validationPredicates.map { "\($0)" }, [])
        
        let rships = entity.relationshipsByName.map { $0.key }
        let expectedRshipKeys = Set([
            "imageModels",
        ])
        expectNoDifference(Set(rships), expectedRshipKeys)
        
        let imageModels = try XCTUnwrap(entity.relationshipsByName["imageModels"])
        XCTAssertEqual(imageModels.destinationEntity!.name, "ImageModel")
        XCTAssertEqual(imageModels.inverseRelationship!.name, "rabbit")
        XCTAssertTrue(imageModels.isToMany)

    }
    
    func testParseStruct() throws {
        let data = try Data.jsonData(forFilePrefix: "rabbit")
        let rStruct = try JSONDecoder().decode(RabbitStruct.self, from: data)
        
        let rabbit = try storage.upsert(rabbitStruct: rStruct).get()
        
        // swiftlint:disable line_length
        let desc = "Meet Honey & Juniper! These two sisters are about 7 months old and must be adopted together. They may be small, but they need a lot of space to play and more importantly, to get away from each other when they want some alone time. They are currently living in a 10x11 bunny proofed room, but if they could talk, they would probably say they could use a little more square footage. They love to munch on hay all day long, but in the morning they circle like sharks for pellets. They also enjoy eating veggies twice a day. They are still pretty shy, but they will warm up to you if you give them time. They are also quite active and would prefer to run around than be pet. They make great bunny entertainment AKA bunny TV! Currently fostering in the Charlotte area."
        let photo1 = "https://www.shelterluv.com/sites/default/files/animal_pics/37724/2022/04/12/10/20220412103758.png"
        let photo2 = "https://www.shelterluv.com/sites/default/files/animal_pics/37724/2022/09/15/07/20220915072532.png"
        // swiftlint:enable line_length

        // Check raw values
        expectNoDifference(rabbit.internalId, "52423098")
        expectNoDifference(rabbit.name, "Honey")
        expectNoDifference(rabbit.sex, "female")
        expectNoDifference(rabbit.weight, 4.0962)
        expectNoDifference(rabbit.altered, true)
        expectNoDifference(rabbit.age, 2.6666667)
        expectNoDifference(rabbit.rabbitDescription, desc)

        let photoUrls = rabbit.photos.map { $0.url }
        expectNoDifference(Set(photoUrls), Set([photo1, photo2]))
        
        // Check cover photo flag
        try rabbit.photos.forEach { iModel in
            let url = try XCTUnwrap(iModel.url)
            expectNoDifference(iModel.isCover, url == photo1)
        }
        
        let coverUrl = try XCTUnwrap(rabbit.coverPhoto?.url)
        expectNoDifference(coverUrl, photo1)
    }
}
