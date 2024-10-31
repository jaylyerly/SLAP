//
//  ListViewControllerTests.swift
//  SLAPTests
//
//  Created by Jay Lyerly on 10/31/24.
//

import CustomDump
import Foundation
@testable import SLAP
import XCTest

class ListViewControllerTests: TestCase {
    
    var listVC: ListViewController!
    var appEnv: AppEnv!
    
    var fakeApi: FakeApi { appEnv.api as! FakeApi }
    var jsonRabbits = [RabbitStruct]()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        appEnv = .fake()
        listVC = ViewControllerFactory.list(appEnv: appEnv, mode: .adoptables)
        
        // load the JSON data
        let jsonData = try Data.jsonData(forFilePrefix: "rabbits.publishable")
        let list = try JSONDecoder().decode(RabbitList.self, from: jsonData)
        jsonRabbits = list.animals
        expectNoDifference(jsonRabbits.count, 12)
    }
    
    override func tearDownWithError() throws {
        listVC = nil
        appEnv = nil
        try super.tearDownWithError()
    }
    
    func testLoadData() throws {
        // initial condition, list has not been refreshed
        expectNoDifference(fakeApi.didRefreshList, false)
        
        // load the VC
        XCTAssertNotNil(listVC.view)
        XCTWaitUntilEqual(listVC.dataSource?.snapshot().numberOfItems, 0)
        
        // On load, VC should refresh the list
        XCTWaitUntilEqual(fakeApi.didRefreshList, true)
        
        // Fake the result of loading the list by pushing data to storage.
        appEnv.storage.api(appEnv.api, didReceiveList: jsonRabbits, forEndpointName: RabbitList.publishableEndpointName)
        
        // Eventually, the datasource should get 12 items
        let dataSource = try XCTUnwrap(listVC.dataSource)
        XCTWaitUntilEqual(dataSource.snapshot().numberOfItems, 12)
        // And the internalIds should match the json Input
        let snapshotIds = dataSource.snapshot().itemIdentifiers.compactMap { $0.rabbitInternalId }
        let jsonIds = jsonRabbits.map { $0.internalId }
        expectNoDifference(Set(snapshotIds), Set(jsonIds))
        
        // get new data
        let newJson = [jsonRabbits[0], jsonRabbits[1], jsonRabbits[2]]
        appEnv.storage.api(appEnv.api, didReceiveList: newJson, forEndpointName: RabbitList.publishableEndpointName)
        XCTWaitUntilEqual(dataSource.snapshot().numberOfItems, 3)
        // And now the ListItem ids should match the newJson list
        let newSnapshotIds = dataSource.snapshot().itemIdentifiers.compactMap { $0.rabbitInternalId }
        let newJsonIds = newJson.map { $0.internalId }
        expectNoDifference(Set(newSnapshotIds), Set(newJsonIds))
    }
    
    func testPullToRefresh() {
        XCTAssertNotNil(listVC.view)

        // reset the 'didRefresh' count
        fakeApi.didRefreshList = false
        
        // Make sure the refresh control was installed
        XCTAssertTrue(listVC.collectionView.refreshControl === listVC.refreshControl)

        // Make sure the action is connected
        assertActionsContain(
            "didPullToRefresh:",
            forControl: listVC.refreshControl,
            withTarget: listVC,
            forEvent: .valueChanged
        )
        
        // Perform action
        listVC.didPullToRefresh(listVC.refreshControl)
        
        // Eventually, the api should update
        XCTWaitUntilTrue(fakeApi.didRefreshList)
    }
    
    func testCell() throws {
        XCTAssertNotNil(listVC.view)

        let rStruct = jsonRabbits.sorted(using: SortDescriptor(\.name))[0]
        let rabbitId = rStruct.internalId
        
        let dataSource = try XCTUnwrap(listVC.dataSource)
        // Push some data
        appEnv.storage.api(appEnv.api, didReceiveList: jsonRabbits, forEndpointName: RabbitList.publishableEndpointName)
        XCTWaitUntilEqual(dataSource.snapshot().numberOfItems, 12)

        let cell = dataSource.collectionView(listVC.collectionView, cellForItemAt: IndexPath(row: 0, section: 0))
        let listCell = try XCTUnwrap(cell as? ListCell)
        
        expectNoDifference(listCell.nameView.text, rStruct.name)
        expectNoDifference(listCell.favButton.isSelected, false)        // not a favorite
        XCTAssertFalse(try appEnv.storage.rabbit(withInternalId: rabbitId).isFavorite)

        assertActionsContain("toggleFavorite:", forControl: listCell.favButton, withTarget: listCell)
        
        listCell.favButton.sendActions(for: .touchUpInside)
        
        try XCTWaitUntilTrue(try appEnv.storage.rabbit(withInternalId: rabbitId).isFavorite)
    }
}
