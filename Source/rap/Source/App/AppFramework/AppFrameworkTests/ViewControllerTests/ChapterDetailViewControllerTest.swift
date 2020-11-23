//
//  ChapterDetailViewControllerTest.swift
//  AppFramework
//
//  Created by Philips on 9/26/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import AppFramework
@testable import ConsentWidgets

import PlatformInterfaces
import AppInfra

var consentDefinitions: [ConsentDefinition]!
var returnedConsentDefinitionStatuses: [ConsentDefinitionStatus]!
var consentDefinitionStatus :ConsentDefinitionStatus!
var appInfra: AIAppInfra!
var consentManagerMock:AIConsentManagerProtocolmock!
var JITInterfaceMock :JITViewControllerMock!
var postResult = false


class ChapterDetailViewControllerTest: XCTestCase {
    var chapterDetailViewController: ChapterDetailsViewController?
    var chapterDetailPresenterMock:BasePresenter?
    var mockUser : TestDIUser!
    
    override func setUp() {
        super.setUp()
        let storyBoard = UIStoryboard(name: Constants.CHAPTERLIST_STORYBOARD_NAME, bundle: nil)
        chapterDetailViewController = storyBoard.instantiateViewController(withIdentifier: Constants.CHAPTER_DETAILS_STORYBOARD_ID) as? ChapterDetailsViewController
        chapterDetailPresenterMock = ChapterListPresenterMock(_viewController: chapterDetailViewController)
        chapterDetailViewController?.presenter = chapterDetailPresenterMock
        chapterDetailViewController?.chapterDetailsArray = [CoCoDemoDetails(cocoDemoName: "TestCoCoName", cocoDemoEventId: "TestCocoEventId")]
        chapterDetailViewController?.loadViewIfNeeded()
        self.mockUser = TestDIUser()
    }
    
    override func tearDown() {
        chapterDetailViewController = nil
        chapterDetailPresenterMock = nil
        super.tearDown()
    }

    func testNavigateToNextState() {
        chapterDetailViewController?.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
        let controller = (chapterDetailPresenterMock?.onEvent("TEST_EVENT_ID"))
        XCTAssertNil(controller)
    }

    func testChapterNameIsDisplayedInList() {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CHAPTER_TABLE_CELL_IDENTIFIER)
        chapterDetailViewController?.tableView = tableView
        chapterDetailViewController?.tableView.reloadData()
        XCTAssertEqual(chapterDetailViewController?.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)).textLabel?.text, "TestCoCoName")
    }

    private func givenTheConsentDefinationStatus(){
        let momentConsentDefinition = ConsentDefinition(type: "moment", text: "sampleTest", helpText: "sampleHelpText", version: 1, locale: "en-US")
        consentDefinitionStatus = ConsentDefinitionStatus(status: ConsentStates.inactive, versionStatus: ConsentVersionStates.appVersionIsHigher, consentDefinition: momentConsentDefinition)
    }

    private func givenPartiallyMockedAppInfra(internetReachable:Bool){
        appInfra = AIAppInfra()
        let restClientMock = AppInfraRestClientMock()
        restClientMock.internetReachable = internetReachable
        let localisationMock = AppInfraLocalisationMock()
        appInfra.restClient = restClientMock
        appInfra.internationalization = localisationMock
    }

    private func whenOnEventCalledWithEventID_TestDataServicesEvent(){
        chapterDetailViewController?.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
        _ = (chapterDetailPresenterMock?.onEvent("TestDataServicesEvent"))
    }

}
