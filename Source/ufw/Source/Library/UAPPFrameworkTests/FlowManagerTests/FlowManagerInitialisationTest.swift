/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

@testable import UAPPFrameworkDev
import XCTest


class MockBaseFlowManager: BaseFlowManager {
    
    override func populateStateMap(_ stateMap: inout StateMapType) {
        return
    }
    
    override func populateConditionMap(_ conditionMap : inout ConditionMapType) {
        return
    }
}

class FlowManagerInitialisationTest: XCTestCase {
    
    var flowManager : BaseFlowManager?
    
    override func setUp() {
        super.setUp()

        flowManager = MockBaseFlowManager()
    }
    
    func testLoadJsonFileSuccess() {
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: UnitTestConstants.FLOW_CONFIG_FILE_NAME, withExtension: UnitTestConstants.JSON_TYPE)
        let expectationHandler = expectation(description: UnitTestConstants.EXPECTATION_HANDLER_IDENTIFIER)

        flowManager?.initialize(withAppFlowJsonPath: (fileURL?.path)!, successBlock: {
                expectationHandler.fulfill()
                XCTAssertEqual(Thread.current, Thread.main)
            }, failureBlock: { (error) in
                expectationHandler.fulfill()
        })
        
        self.waitForExpectations(timeout: UnitTestConstants.STANDARD_WAIT_TIME) { (error) in
            if error == nil {
                XCTAssertNotNil(self.flowManager?.appFlowModel)
            }
        }
    }
    
    func testLoadJsonFileInBackGroundSuccess() {
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: UnitTestConstants.FLOW_CONFIG_FILE_NAME, withExtension: UnitTestConstants.JSON_TYPE)
        let customQueue = DispatchQueue(label: UnitTestConstants.QUEUE_IDENTIFIER, attributes: DispatchQueue.Attributes.concurrent)
        let expectationHandler = expectation(description: UnitTestConstants.EXPECTATION_HANDLER_IDENTIFIER)
        var calleeThread : Thread?
        
        customQueue.async {
            calleeThread = Thread.current
            self.flowManager?.initialize(withAppFlowJsonPath: (fileURL?.path)!, successBlock: {
                expectationHandler.fulfill()
                XCTAssertEqual(calleeThread, Thread.current)
                }, failureBlock: { (error) in
                    expectationHandler.fulfill()
            })
        }
        
        self.waitForExpectations(timeout: UnitTestConstants.STANDARD_WAIT_TIME) { (error) in
            if error == nil {
                XCTAssertNotNil(self.flowManager?.appFlowModel)
            }
        }
    }
    
    func testLoadJsonFileFailure() {
        let expectationHandler = expectation(description: UnitTestConstants.EXPECTATION_HANDLER_IDENTIFIER)
        var flowError : FlowManagerErrors?
        
        flowManager?.initialize(withAppFlowJsonPath: UnitTestConstants.BLANK_STRING, successBlock: {
                expectationHandler.fulfill()
            }, failureBlock: { (error) in
                flowError = error
                expectationHandler.fulfill()
        })
        
        self.waitForExpectations(timeout: UnitTestConstants.STANDARD_WAIT_TIME) { (error) in
            if error == nil {
                XCTAssertEqual(flowError?.message(), FlowManagerErrors.fileNotFoundError.message())
            }
        }
    }
    
    func testLoadJsonFileInBackGroundFailure() {
        let customQueue = DispatchQueue(label: UnitTestConstants.QUEUE_IDENTIFIER, attributes: DispatchQueue.Attributes.concurrent)
        let expectationHandler = expectation(description: UnitTestConstants.EXPECTATION_HANDLER_IDENTIFIER)
        var calleeThread : Thread?
        var flowError : FlowManagerErrors?
        
        customQueue.async {
            calleeThread = Thread.current
            self.flowManager?.initialize(withAppFlowJsonPath: UnitTestConstants.BLANK_STRING, successBlock: {
                expectationHandler.fulfill()
                XCTAssertEqual(calleeThread, Thread.current)
                }, failureBlock: { (error) in
                    flowError = error
                    expectationHandler.fulfill()
            })
        }
        
        self.waitForExpectations(timeout: UnitTestConstants.STANDARD_WAIT_TIME) { (error) in
            if error == nil {
                XCTAssertEqual(flowError?.message(), FlowManagerErrors.fileNotFoundError.message())
            }
        }
    }
    
    func testLoadJsonFileFormatError() {
        let expectationHandler = expectation(description: UnitTestConstants.EXPECTATION_HANDLER_IDENTIFIER)
        var flowError : FlowManagerErrors?
        
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: UnitTestConstants.FLOW_WRONG_CONFIG_FILE_NAME, withExtension: UnitTestConstants.JSON_TYPE)
        
        flowManager?.initialize(withAppFlowJsonPath: (fileURL?.path)!, successBlock: {
                expectationHandler.fulfill()
            }, failureBlock: { (error) in
                flowError = error
                expectationHandler.fulfill()
        })
        
        self.waitForExpectations(timeout: UnitTestConstants.STANDARD_WAIT_TIME) { (error) in
            if error == nil {
                XCTAssertEqual(flowError?.message(), FlowManagerErrors.jsonSyntaxError.message())
            }
        }
    }
    
    func testModelLoadError() {
        let expectationHandler = expectation(description: UnitTestConstants.EXPECTATION_HANDLER_IDENTIFIER)
        
        flowManager?.initialize(withAppFlowJsonPath: UnitTestConstants.BLANK_STRING, successBlock: {
            expectationHandler.fulfill()
            }, failureBlock: { (error) in
                expectationHandler.fulfill()
            })
        
        self.waitForExpectations(timeout: UnitTestConstants.STANDARD_WAIT_TIME) { (error) in
            if error == nil {
                XCTAssertNil(self.flowManager?.appFlowModel)
            }
        }
    }

    func testModelWrongJson() {
        let expectationHandler = expectation(description: UnitTestConstants.EXPECTATION_HANDLER_IDENTIFIER)
        
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: UnitTestConstants.FLOW_WRONG_CONFIG_FILE_NAME, withExtension: UnitTestConstants.JSON_TYPE)
        flowManager?.initialize(withAppFlowJsonPath: (fileURL?.path)!, successBlock: {
            expectationHandler.fulfill()
            }, failureBlock: { (error) in
                expectationHandler.fulfill()
        })
        
        self.waitForExpectations(timeout: UnitTestConstants.STANDARD_WAIT_TIME) { (error) in
            if error == nil {
                XCTAssertNil(self.flowManager?.appFlowModel)
            }
        }
    }
    
    func testFlowDuplicateInitialisation() {
        let expectationHandler = expectation(description: UnitTestConstants.EXPECTATION_HANDLER_IDENTIFIER)
        
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: UnitTestConstants.FLOW_CONFIG_FILE_NAME, withExtension: UnitTestConstants.JSON_TYPE)
        flowManager?.initialize(withAppFlowJsonPath: (fileURL?.path)!, successBlock: {
            expectationHandler.fulfill()
            }, failureBlock: { (error) in
            expectationHandler.fulfill()
        })
        
        self.waitForExpectations(timeout: UnitTestConstants.STANDARD_WAIT_TIME) { (error) in
            if error == nil {
                let expectationHandler = self.expectation(description: UnitTestConstants.EXPECTATION_HANDLER_IDENTIFIER)
                var flowError : FlowManagerErrors?
                
                self.flowManager?.initialize(withAppFlowJsonPath: (fileURL?.path)!, successBlock: {
                        expectationHandler.fulfill()
                    }, failureBlock: { (error) in
                        flowError = error
                        expectationHandler.fulfill()
                })
                
                self.waitForExpectations(timeout: UnitTestConstants.STANDARD_WAIT_TIME) { (error) in
                    if error == nil {
                        XCTAssertEqual(flowError?.message(), FlowManagerErrors.flowManagerAlreadyInitializedError.message())
                    }
                }
            }
        }
    }
}
