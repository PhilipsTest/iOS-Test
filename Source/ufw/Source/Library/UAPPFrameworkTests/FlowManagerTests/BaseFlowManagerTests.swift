/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import UAPPFrameworkDev

class BaseFlowManagerTests: XCTestCase {
    
    var flowManager : BaseFlowManager?
    
    override func setUp() {
        super.setUp()
        flowManager = FlowManager.sharedInstance
    }
    
    override func tearDown() {
        flowManager?.appStack.removeAll()
        super.tearDown()
    }
    
    //MARK: API testing with error cases
    
    func testGetCondition() {
        initializeFlowManager()
        XCTAssertEqual(flowManager?.getCondition(AppConditions.IsLoggedIn)?.conditionId, LoginCondition().conditionId)
    }
    
    func testGetConditionFailure() {
        initializeFlowManager()
        XCTAssertNil(flowManager?.getCondition(UnitTestConstants.FAKE_KEY))
    }
    
    func testGetConditionForBlankValue() {
        initializeFlowManager()
        XCTAssertNil(flowManager?.getCondition(UnitTestConstants.BLANK_STRING))
    }
    
    func testGetState() {
        initializeFlowManager()
        XCTAssertEqual(flowManager?.getState(AppStates.Home)?.stateId, HomeState().stateId)
    }
    
    func testGetStateForBlankValue() {
        initializeFlowManager()
        XCTAssertNil(flowManager?.getState(UnitTestConstants.BLANK_STRING))
    }
    
    func testGetStateFailure() {
        initializeFlowManager()
        XCTAssertNil(flowManager?.getState(UnitTestConstants.FAKE_KEY))
    }
    
    func testPopulateStateMap() {
        initializeFlowManager()
        let oldMapSize = flowManager!.stateMap.count
        flowManager!.stateMap[UnitTestConstants.FAKE_KEY] = HomeState()
        let newMapSize = flowManager!.stateMap.count
        XCTAssertEqual(newMapSize, oldMapSize+1)
    }
    
    func testPopulateStateMapDuplicate() {
        initializeFlowManager()
        let oldStateMapSize = flowManager!.stateMap.count
        flowManager?.populateStateMap(&flowManager!.stateMap)
        let newStateMapSize = flowManager!.stateMap.count
        XCTAssertEqual(oldStateMapSize, newStateMapSize)
    }
    
    func testPopulateConditionMap() {
        initializeFlowManager()
        let oldConditionMapSize = flowManager!.conditionMap.count
        flowManager!.conditionMap[UnitTestConstants.FAKE_KEY] = LoginCondition()
        let newConditionMapSize = flowManager!.conditionMap.count
        XCTAssertEqual(newConditionMapSize, oldConditionMapSize+1)
    }
    
    func testPopulateConditionMapDuplicate() {
        initializeFlowManager()
        let oldMapSize = flowManager!.conditionMap.count
        flowManager?.populateConditionMap(&flowManager!.conditionMap)
        let newMapSize = flowManager!.conditionMap.count
        XCTAssertEqual(oldMapSize, newMapSize)
    }
    
    func testGetNextStateSuccess() {
        var state : BaseState?
        initializeFlowManager()
        do {
            state = try flowManager?.getNextState(HomeState(), forEventId: UnitTestConstants.APP_START_EVENT)
        } catch {
            XCTAssertNil(state)
        }
        XCTAssertEqual(state?.stateId, HamburgerMenuState().stateId)
    }
    
    func testGetNextStateSuccessWithCaseInsensitiveEvent() {
        var state : BaseState?
        initializeFlowManager()
        do {
            state = try flowManager?.getNextState(HamburgerMenuState(), forEventId: UnitTestConstants.HAMBURGER_HOME_CLICK_CAPITALISED)
        } catch {
            XCTAssertNil(state)
        }
        XCTAssertEqual(state?.stateId, HomeState().stateId)
    }
    
    func testGetNextStateSuccessWithBlankStateOutput() {
        var state : BaseState?
        initializeFlowManager()
        do {
            state = try flowManager?.getNextState(HamburgerMenuState(), forEventId: UnitTestConstants.HAMBURGER_HOME_CLICK_FAKE)
        } catch {
            let error = error as! FlowManagerErrors
            XCTAssertEqual(error.message() , FlowManagerErrors.noStateFoundError.message())
        }
        XCTAssertNil(state)
    }
    
    func testGetNextStateWithBlankEvent() {
        var state : BaseState?
        initializeFlowManager()
        do {
            state = try flowManager?.getNextState(HamburgerMenuState(), forEventId: UnitTestConstants.BLANK_STRING)
        } catch {
            let error = error as! FlowManagerErrors
            XCTAssertEqual(error.message() , FlowManagerErrors.noEventFoundError.message())
        }
        XCTAssertNil(state)
    }
    
    func testGetNextStateWithNilEvent() {
        var state : BaseState?
        initializeFlowManager()
        do {
            state = try flowManager?.getNextState(HamburgerMenuState(), forEventId: nil)
        } catch {
            let error = error as! FlowManagerErrors
            XCTAssertEqual(error.message() , FlowManagerErrors.nullEventError.message())
        }
        XCTAssertNil(state)
    }
    
    func testGetNextStateWithNilCurrentState() {
        var state : BaseState?
        initializeFlowManager()
        do {
            state = try flowManager?.getNextState(nil, forEventId: UnitTestConstants.BLANK_STRING)
        } catch {
            let error = error as! FlowManagerErrors
            XCTAssertEqual(error.message() , FlowManagerErrors.nullStateError.message())
        }
        XCTAssertNil(state)
    }
    
    func testGetNextStateWithStateIdError() {
        var state : BaseState?
        initializeFlowManager()
        do {
            state = try flowManager?.getNextState(DummyState(), forEventId: UnitTestConstants.BLANK_STRING)
        } catch {
            let error = error as! FlowManagerErrors
            XCTAssertEqual(error.message() , FlowManagerErrors.stateIdNotFoundError.message())
        }
        XCTAssertNil(state)
    }
    
    func testGetNextStateWithNoStateFoundError() {
        var state : BaseState?
        initializeFlowManager()
        do {
            state = try flowManager?.getNextState(HamburgerMenuState(), forEventId: UnitTestConstants.HAMBURGER_CONNECTIVITY_CLICK)
        } catch {
            let error = error as! FlowManagerErrors
            XCTAssertEqual(error.message() , FlowManagerErrors.noStateFoundError.message())
        }
        XCTAssertNil(state)
    }
    
    func testGetNextStateWithNoConditionFoundError() {
        var state : BaseState?
        initializeFlowManager()
        do {
            state = try flowManager?.getNextState(HamburgerMenuState(), forEventId: UnitTestConstants.HAMBURGER_HELP_CLICK)
        } catch {
            let error = error as! FlowManagerErrors
            XCTAssertEqual(error.message() , FlowManagerErrors.noConditionFoundError.message())
        }
        XCTAssertNil(state)
    }
    
    func testGetNextStateWithInitialWrongStateError() {
        var state : BaseState?
        initializeFlowManager()
        do {
            state = try flowManager?.getNextState(FakeState(), forEventId: UnitTestConstants.HAMBURGER_HELP_CLICK)
        } catch {
            let error = error as! FlowManagerErrors
            XCTAssertEqual(error.message() , FlowManagerErrors.noStateFoundError.message())
        }
        XCTAssertNil(state)
    }
    
    func testErrorCode() {
        var state : BaseState?
        initializeFlowManager()
        do {
            state = try flowManager?.getNextState(HamburgerMenuState(), forEventId: UnitTestConstants.HAMBURGER_HELP_CLICK)
        } catch {
            let error = error as! FlowManagerErrors
            XCTAssertEqual(error.code(), FlowManagerErrors.noConditionFoundError.code())
        }
        XCTAssertNil(state)
    }
    
    func testErrorConditionId() {
        initializeFlowManager()
        XCTAssertEqual(FlowManagerErrors.conditionIdNotFoundError.message(), FlowManagerErrors.conditionIdNotFoundError.message())
    }
    
    func testGetNextStateWithFlowManagerInitialisationError() {
        var state : BaseState?
        let flowManager = MockBaseFlowManager()
        
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: UnitTestConstants.FLOW_WRONG_CONFIG_FILE_NAME, withExtension: UnitTestConstants.JSON_TYPE)
        let expectationHandler = self.expectation(description: UnitTestConstants.EXPECTATION_HANDLER_IDENTIFIER)
        flowManager.initialize(withAppFlowJsonPath: (fileURL?.path)!, successBlock: {
            expectationHandler.fulfill()
            }, failureBlock: {(error) in
                expectationHandler.fulfill()
        })
        self.waitForExpectations(timeout: UnitTestConstants.STANDARD_WAIT_TIME, handler: nil)
        
        do {
            state = try flowManager.getNextState(HamburgerMenuState(), forEventId: UnitTestConstants.HAMBURGER_HOME_CLICK)
        } catch {
            let error = error as! FlowManagerErrors
            XCTAssertEqual(error.message() , FlowManagerErrors.flowManagerInitializationError.message())
        }
        XCTAssertNil(state)
    }
    
    func testGetNextStateWithOnlyEvent() {
        var state : BaseState?
        var secondState : BaseState?
        initializeFlowManager()
        
        do {
            state = try flowManager?.getNextState(WelcomeState(), forEventId: UnitTestConstants.WELCOME_SKIP_BUTTON_CLICK)
        } catch {
            XCTAssertNil(state)
        }
        
        do {
            secondState = try flowManager?.getNextState(UnitTestConstants.HAMBURGER_HOME_CLICK)
        } catch {
            XCTAssertNil(secondState)
        }
        
        XCTAssertEqual(secondState?.stateId, HomeState().stateId)
    }
    
    func testGetNextStateWithOnlyEventFailure() {
        var state : BaseState?
        var secondState : BaseState?
        initializeFlowManager()
        
        do {
            state = try flowManager?.getNextState(WelcomeState(), forEventId: UnitTestConstants.WELCOME_SKIP_BUTTON_CLICK)
        } catch {
            XCTAssertNil(state)
        }
        
        do {
            secondState = try flowManager?.getNextState(UnitTestConstants.FAKE_KEY)
        } catch {
            let error = error as! FlowManagerErrors
            XCTAssertEqual(error.message() , FlowManagerErrors.noEventFoundError.message())
        }
        XCTAssertNil(secondState)
    }
    
    //MARK: Back Handling API testing
    
    func testPushState() {
        initializeFlowManager()
        pushStatesFromOriginalState(HamburgerMenuState(), withEventIds: [UnitTestConstants.HAMBURGER_HOME_CLICK,UnitTestConstants.HAMBURGER_ABOUT_CLICK,UnitTestConstants.HAMBURGER_SETTINGS_CLICK], withFlowManager: flowManager!)
        XCTAssertEqual(flowManager?.appStack.count, 3)
        
    }
    
    func testBackState() {
        var state : BaseState?
        initializeFlowManager()
        let originalState = HamburgerMenuState()
        
        pushStatesFromOriginalState(originalState, withEventIds: [UnitTestConstants.HAMBURGER_HOME_CLICK,UnitTestConstants.HAMBURGER_ABOUT_CLICK,UnitTestConstants.HAMBURGER_SETTINGS_CLICK], withFlowManager: flowManager!)
        do {
            state = try flowManager?.getBackState(originalState)
        } catch {
            
        }
        XCTAssertEqual(state?.stateId , flowManager?.getCurrentState()?.stateId)
    }
    
    func testBackStateWithCaseInsensitiveBackEvent() {
        var state : BaseState?
        initializeFlowManager()
        let originalState = WelcomeState()
        let eventIds = [UnitTestConstants.WELCOME_DONE_BUTTON_CLICK,UnitTestConstants.WELCOME_SKIP_BUTTON_CLICK,UnitTestConstants.HAMBURGER_SETTINGS_CLICK]
        pushStatesFromOriginalState(originalState, withEventIds: eventIds, withFlowManager: flowManager!)
        do {
            state = try flowManager?.getBackState()
        } catch {
            
        }
        XCTAssertEqual(flowManager?.appStack.count, 2)
        XCTAssertEqual(flowManager?.getCurrentState()?.stateId , HamburgerMenuState().stateId)
        XCTAssertEqual(state?.stateId , flowManager?.getCurrentState()?.stateId)
    }
    
    func testGetBackStateFailure() {
        var state : BaseState?
        initializeFlowManager()
        let originalState = HamburgerMenuState()
        let eventIds = [UnitTestConstants.HAMBURGER_HOME_CLICK,UnitTestConstants.HAMBURGER_ABOUT_CLICK,UnitTestConstants.HAMBURGER_SETTINGS_CLICK]
        
        pushStatesFromOriginalState(originalState, withEventIds: eventIds, withFlowManager: flowManager!)
        do {
            state = try flowManager?.getBackState(DummyState())
        } catch {
            XCTAssertNil(state)
        }
        XCTAssertEqual(flowManager?.getCurrentState()?.stateId , SettingsState().stateId)
    }
    
    func testGetBackStateWithoutParameterFailure() {
        var state : BaseState?
        initializeFlowManager()
        let originalState = HomeState()
        let eventIds = [UnitTestConstants.HAMBURGER_ABOUT_CLICK,UnitTestConstants.HAMBURGER_SETTINGS_CLICK,UnitTestConstants.HAMBURGER_HOME_CLICK]
        
        pushStatesFromOriginalState(originalState, withEventIds: eventIds, withFlowManager: flowManager!)
        do {
            state = try flowManager?.getBackState()
        } catch {
            XCTAssertNil(state)
        }
        XCTAssertEqual(flowManager?.getCurrentState()?.stateId, HomeState().stateId)
    }
    
    func testCustomBackForRepeatStackState() {
        var state : BaseState?
        initializeFlowManager()
        let originalState = SettingsState()
        let eventIds = [UnitTestConstants.HAMBURGER_HOME_CLICK,UnitTestConstants.HAMBURGER_ABOUT_CLICK,UnitTestConstants.HAMBURGER_HAMBURGER_CLICK]
        pushStatesFromOriginalState(originalState, withEventIds: eventIds, withFlowManager: flowManager!)
        do {
            state = try flowManager?.getBackState(originalState)
        } catch {
            
        }
        XCTAssertEqual(flowManager?.appStack.count, 1)
        XCTAssertEqual(flowManager?.getCurrentState()?.stateId , HomeState().stateId)
        XCTAssertEqual(state?.stateId, flowManager?.getCurrentState()?.stateId)
    }
    
    func testBackStateWithoutParameterAPI() {
        var state : BaseState?
        initializeFlowManager()
        let originalState = SettingsState()
        let eventIds = [UnitTestConstants.HAMBURGER_HOME_CLICK,UnitTestConstants.HAMBURGER_ABOUT_CLICK,UnitTestConstants.HAMBURGER_HAMBURGER_CLICK,UnitTestConstants.HAMBURGER_HOME_CLICK,UnitTestConstants.HAMBURGER_SETTINGS_CLICK]
        pushStatesFromOriginalState(originalState, withEventIds: eventIds, withFlowManager: flowManager!)
        do {
            state = try flowManager?.getBackState()
        } catch {
            
        }
        XCTAssertEqual(flowManager?.appStack.count, 4)
        XCTAssertEqual(flowManager?.getCurrentState()?.stateId, HomeState().stateId)
        XCTAssertEqual(state?.stateId, flowManager?.getCurrentState()?.stateId)
    }
    
    func testCustomBackForNewStackState() {
        var state : BaseState?
        initializeFlowManager()
        let originalState = AboutState()
        let eventIds = [UnitTestConstants.HAMBURGER_HOME_CLICK,UnitTestConstants.HAMBURGER_ABOUT_CLICK,UnitTestConstants.HAMBURGER_SETTINGS_CLICK]
        
        pushStatesFromOriginalState(originalState, withEventIds: eventIds, withFlowManager: flowManager!)
        let stateCount = flowManager?.appStack.count
        
        do {
            state = try flowManager?.getBackState(originalState)
        } catch {
            
        }
        XCTAssertEqual(flowManager?.appStack.count, stateCount)
        XCTAssertEqual(flowManager?.getCurrentState()?.stateId, WelcomeState().stateId)
        XCTAssertEqual(state?.stateId, flowManager?.getCurrentState()?.stateId)
    }
}

extension BaseFlowManagerTests {
    
    func initializeFlowManager() {
        let testBundle = Bundle(for: type(of: self))
        let fileURL = testBundle.url(forResource: UnitTestConstants.FLOW_CONFIG_FILE_NAME, withExtension: UnitTestConstants.JSON_TYPE)
        let expectationHandler = self.expectation(description: UnitTestConstants.EXPECTATION_HANDLER_IDENTIFIER)
        
        flowManager?.initialize(withAppFlowJsonPath: (fileURL?.path)!, successBlock: {
            expectationHandler.fulfill()
            }, failureBlock: {(error) in
                expectationHandler.fulfill()
        })
        
        self.waitForExpectations(timeout: UnitTestConstants.STANDARD_WAIT_TIME, handler: nil)
    }

    func pushStatesFromOriginalState(_ state : BaseState,withEventIds : [String], withFlowManager : BaseFlowManager) {
        if withEventIds.count > 0 {
            for eventId in withEventIds {
                do {
                    try withFlowManager.getNextState(state, forEventId: eventId)
                } catch {

                }
            }
        }
    }
}
