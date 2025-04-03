//
//  DetailViewControllerTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/31/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

class DetailViewControllerTests: TestCase {
    
    var detailVC: DetailViewController!
    var appEnv: AppEnv!
    var rStruct: RabbitStruct!
    
    var webLinks: FakeWebLinks { appEnv.webLinks as! FakeWebLinks }
    var config: Config { appEnv.config }
    var api: FakeApi { appEnv.api as! FakeApi }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        appEnv = .fake()
        
        // Get some JSON data
        let data = try Data.jsonData(forFilePrefix: "rabbit")
        rStruct = try JSONDecoder().decode(RabbitStruct.self, from: data)
        importJson([rStruct])
        
        detailVC = ViewControllerFactory.detail(appEnv: appEnv, internalId: rStruct.internalId)
    }
    
    override func tearDownWithError() throws {
        rStruct = nil
        detailVC = nil
        appEnv = nil
        try super.tearDownWithError()
    }
    
    func importJson(_ json: [Codable]) {
        appEnv.storage.api(appEnv.api, didReceiveList: json, forEndpointName: RabbitList.publishableEndpointName)
    }

    func testDefaultRender() throws {
        XCTAssertNotNil(detailVC.view)
        
        let age = try XCTUnwrap(rStruct.age)
        let weight = try XCTUnwrap(rStruct.weight)
        
        expectNoDifference(detailVC.title, rStruct.name)
        expectNoDifference(detailVC.ageLabel.text, String(format: "Age: %.0f years", age))
        expectNoDifference(detailVC.weightLabel.text, String(format: "Weight: %.0f lbs", weight))
        expectNoDifference(detailVC.descriptionLabel.text, rStruct.rabbitDescription)

        // data should have two photos
        expectNoDifference(rStruct.photos.count, 2)
        // so the photo stack should have two UIImageView children
        let imageViews = detailVC.imageStack.arrangedSubviews.compactMap { $0 as? UIImageView }
        expectNoDifference(imageViews.count, 2)
    }
    
    func testDataUpdate() throws {
        XCTAssertNotNil(detailVC.view)

        // Initial state of description
        expectNoDifference(detailVC.descriptionLabel.text, rStruct.rabbitDescription)

        // make a copy of the json data and alter the description
        let newJson = try XCTUnwrap(rStruct)
        let lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        newJson.rabbitDescription = lorem
        
        // Send the new data through the import pipeline
        importJson([newJson])
        
        // Eventually, the text should update
        XCTWaitUntilEqual(detailVC.descriptionLabel.text, lorem)
    }
    
    func testToggleFavorite() throws {
        XCTAssertNotNil(detailVC.view)

        // Initial state is not-favorite
        expectNoDifference(detailVC.rabbit?.isFavorite, false)

        // Make sure the action is connected
        assertBarButtonAction("toggleFavorite:",
                              forBarButtonItem: detailVC.navigationItem.rightBarButtonItem,
                              withTarget: detailVC)
        
        // Perform action
        detailVC.toggleFavorite(detailVC.navigationItem.rightBarButtonItem)
        
        // Eventually, the text should update
        XCTWaitUntilTrue(detailVC.rabbit?.isFavorite)
    }
    
    func testRefresh() throws {
        XCTAssertNotNil(detailVC.view)
        
        // Initial condition, api has not been refreshed
        expectNoDifference(api.didRefreshSingle, false)
        expectNoDifference(api.singleRefreshInternalIds, [])

        // Make sure the refresh control was installed
        XCTAssertTrue(detailVC.scrollView.refreshControl === detailVC.refreshControl)

        // Make sure the action is connected
        assertActionsContain(
            "didPullToRefresh:",
            forControl: detailVC.refreshControl,
            withTarget: detailVC,
            forEvent: .valueChanged
        )
        
        // Perform action
        detailVC.didPullToRefresh(detailVC.refreshControl)
        
        // Eventually, the api should update
        XCTWaitUntilTrue(api.didRefreshSingle)
        XCTWaitUntilTrue(api.singleRefreshInternalIds.contains(detailVC.internalId))
    }

}
