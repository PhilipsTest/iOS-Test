//
//  ChapterListPresenterTest.swift
//  AppFramework
//
//  Created by Philips on 9/19/17.
//  Copyright © 2017 Philips. All rights reserved.
//
import XCTest
import Foundation
@testable import AppFramework

class ChapterListPresenterTest : XCTestCase{
    
    let chapterListPresenterObject = ChapterListPresenter(_viewController: ChapterListViewController())
    
    func testChapterListPresenterCheckNil(){
        XCTAssertNotNil(chapterListPresenterObject, "Chapter List Presenter Object has not been intialized")
    }
    
    func testJsonParserInPresenter(){
       let chapterDetailsArray  = (chapterListPresenterObject.jsonParser({
            // self.chapterDetailsArray = jsonArray
            },
                                                                failureBlock: {_ in 
        }))
        
        XCTAssertNotNil(chapterDetailsArray, "Json Parser gives the object of ChapterDetail")
    }
    
    
    
}
