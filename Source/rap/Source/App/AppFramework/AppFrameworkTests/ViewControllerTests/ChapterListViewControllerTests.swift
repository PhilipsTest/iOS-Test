/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework

class ChapterListViewControllerTests: XCTestCase {
    var chapterListViewController: ChapterListViewController!
    var presenterMock: ChapterListPresenterMock!

    override func setUp() {
        super.setUp()
        let testData = [
            ChapterDetails(chapterName: "TEST_CHAPTER_NAME", chapterCoCoDemoApps: nil, chapterEventId: "TEST_EVENT_ID"),
            ChapterDetails(chapterName: "TEST_CHAPTER_NAME2", chapterCoCoDemoApps: [CoCoDemoDetails(cocoDemoName: "TestCoCoName", cocoDemoEventId: "TestCocoEventId")], chapterEventId: nil)
        ]
        let storyBoard = UIStoryboard(name: Constants.CHAPTERLIST_STORYBOARD_NAME, bundle: nil)
        chapterListViewController = storyBoard.instantiateViewController(withIdentifier: Constants.CHAPTERLIST_VIEWCONTROLLER_STORYBOARD_ID) as! ChapterListViewController
        chapterListViewController.chapterDetailsArray = testData

        presenterMock = ChapterListPresenterMock(_viewController: chapterListViewController)
        chapterListViewController.presenter = presenterMock
        chapterListViewController.loadViewIfNeeded()
    }

    override func tearDown() {
        chapterListViewController = nil
        presenterMock = nil
        super.tearDown()
    }

    func testNavigateToNextState() {
        chapterListViewController.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
       
    }

    func testNavigateToChapterDetail() {
        chapterListViewController.tableView(UITableView(), didSelectRowAt: IndexPath(row: 1, section: 0))
    }

    
}

class ChapterListPresenterMock: ChapterListPresenter {

    private var onEventCallArguments = [String]()
    private var navigateToChapterDetailCallArguments = [ChapterDetailsViewController]()

    var testData = [
        ChapterDetails(chapterName: "TEST_CHAPTER_NAME", chapterCoCoDemoApps: nil, chapterEventId: "TEST_EVENT_ID"),
        ChapterDetails(chapterName: "TEST_CHAPTER_NAME2", chapterCoCoDemoApps: [CoCoDemoDetails(cocoDemoName: "TestCoCoName", cocoDemoEventId: "TestCocoEventId")], chapterEventId: nil)
    ]

    override func jsonParser(_ successBlock: () -> (), failureBlock: (JSONParsingErrors) -> ()) -> [ChapterDetails] {
        return testData
    }

    override func onEvent(_ componentId: String) -> UIViewController? {
        onEventCallArguments.append(componentId)
        return nil
    }

    override func navigateToChapterDetail(_ chapterDetailsViewController: ChapterDetailsViewController) {
        navigateToChapterDetailCallArguments.append(chapterDetailsViewController)
    }

    func navigateToChapterDetailWasCalled(withTitle: String) -> Bool {
        return navigateToChapterDetailCallArguments.contains(where: { vc in vc.titleForView == withTitle })
    }

    func onEventWasCalled(with eventId: String) -> Bool {
        return onEventCallArguments.contains(eventId)
    }
}
