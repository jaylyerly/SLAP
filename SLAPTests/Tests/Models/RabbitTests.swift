//
//  RabbitTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/26/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

class RabbitTests: TestCase {
    
    var singleJsonData: Data!
    var listJsonData: Data!
    var publishableListJsonData: Data!

    override func setUpWithError() throws {
        try super.setUpWithError()
        singleJsonData = try Data.jsonData(forFilePrefix: "rabbit")
        listJsonData = try Data.jsonData(forFilePrefix: "rabbits")
        publishableListJsonData = try Data.jsonData(forFilePrefix: "rabbits.publishable")
    }
    
    override func tearDownWithError() throws {
        singleJsonData = nil
        listJsonData = nil
        try super.tearDownWithError()
    }
    
    func testDecodeSingle() throws {        
        let rabbit = try JSONDecoder().decode(Rabbit.self, from: singleJsonData)
        
        // swiftlint:disable line_length
        let desc = "Meet Honey & Juniper! These two sisters are about 7 months old and must be adopted together. They may be small, but they need a lot of space to play and more importantly, to get away from each other when they want some alone time. They are currently living in a 10x11 bunny proofed room, but if they could talk, they would probably say they could use a little more square footage. They love to munch on hay all day long, but in the morning they circle like sharks for pellets. They also enjoy eating veggies twice a day. They are still pretty shy, but they will warm up to you if you give them time. They are also quite active and would prefer to run around than be pet. They make great bunny entertainment AKA bunny TV! Currently fostering in the Charlotte area."
        let photo1 = "https://www.shelterluv.com/sites/default/files/animal_pics/37724/2022/04/12/10/20220412103758.png"
        let photo2 = "https://www.shelterluv.com/sites/default/files/animal_pics/37724/2022/09/15/07/20220915072532.png"
        // swiftlint:enable line_length

        // Check raw values
        XCTAssertEqual(rabbit.internalId, "52423098")
        XCTAssertEqual(rabbit.name, "Honey")
        XCTAssertEqual(rabbit.rawSex, "Female")
        XCTAssertEqual(rabbit.status, "Healthy In Home")
        XCTAssertEqual(rabbit.rawWeight, "4.0962")
        XCTAssertEqual(rabbit.rawAltered, "Yes")
        XCTAssertEqual(rabbit.rawAge, 32)
        XCTAssertEqual(rabbit.rawCoverPhoto, photo1)
        XCTAssertEqual(rabbit.rabbitDescription, desc)
        XCTAssertEqual(rabbit.rawPhotos, [photo1, photo2])

        let url1 = try XCTUnwrap(URL(string: photo1))
        let url2 = try XCTUnwrap(URL(string: photo2))
        // Check derived values
        XCTAssertEqual(rabbit.sex, .female)
        XCTAssertEqual(rabbit.weight, 4)
        XCTAssertTrue(rabbit.altered)
        XCTAssertEqual(rabbit.age, 2)
        XCTAssertEqual(rabbit.coverPhoto, url1)
        XCTAssertEqual(rabbit.photos, [url1, url2])
        
    }
    
    func testDecodeList() throws {
        let rabbitList = try JSONDecoder().decode(RabbitList.self, from: listJsonData)
        
        XCTAssertEqual(rabbitList.success, 1)
        XCTAssertEqual(rabbitList.rawTotalCount, "197")
        XCTAssertEqual(rabbitList.totalCount, 197)
        XCTAssertTrue(rabbitList.hasMore)
        
        XCTAssertEqual(rabbitList.animals.count, 100)
    }
    
    func testDecodePublishableList() throws {
        let rabbitList = try JSONDecoder().decode(RabbitList.self, from: publishableListJsonData)
        
        XCTAssertEqual(rabbitList.success, 1)
        XCTAssertEqual(rabbitList.rawTotalCount, "12")
        XCTAssertEqual(rabbitList.totalCount, 12)
        XCTAssertFalse(rabbitList.hasMore)
        
        XCTAssertEqual(rabbitList.animals.count, 12)
    }
}
