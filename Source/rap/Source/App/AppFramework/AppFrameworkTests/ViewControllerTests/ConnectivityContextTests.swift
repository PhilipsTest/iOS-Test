/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import Reachability
@testable import DIComm
@testable import CommShineLibAdapter
@testable import ShineLib
@testable import AppFramework

class ConnectivityContextTests: BaseXCTestCase {
    var connectivityViewController : ConnectivityViewController! = nil
    var bleContext: BLEContext?
    var node : DINetworkNode?
    var applianceArray = [String]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: Constants.CONNECTIVITYSTORYBOARDNAME, bundle: nil)
        connectivityViewController = (storyboard.instantiateViewController(withIdentifier: Constants.CONNECTIVITYVIEWCONTROLLERSTORYBOARDID) as? ConnectivityViewController)!
        
        do {
            
            SHNInternalCentralManagerMock.mockSHNInternalCentralManager(with: SHNCentralState.ready)
            SHNInternalCentralManagerMock.sharedInstance.waitForFirstStateUpdateSemaphoreMock = DispatchSemaphore(value: 0)
            SHNInternalCentralManagerMock.sharedInstance.delegatesMock = NSHashTable.weakObjects()
            SHNInternalCentralManagerMock.sharedInstance.swizzleCreateDefaultCentral()
            
            bleContext = try BLEContext.defaultContext()
        }
        catch{
        }
        
        node = DINetworkNodeMock.sharedInstance.diNetworkNodeMock()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    // Using BLEContext Mock
    
    func testStartSearchingForDevice(){
        connectivityViewController.bleContext = bleContext
        _ = connectivityViewController.view
        connectivityViewController.startSearchingForDevice()
        doAssertion(.xctAssertEqual, assertObject: nil, derivedState: connectivityViewController.connectionStateLabel!.text, originalState: UnitTestConstants.REFERENCEDEVICE_CONNECTION_STATUS)
    }
    
    func testCreateAppliance(){
        connectivityViewController.bleContext = bleContext
        _ = connectivityViewController.view
        connectivityViewController.createAppliance(node: node!)
        doAssertion(.xctAssertNotNil, assertObject: connectivityViewController.listOfAppliance.count as AnyObject?, derivedState: nil, originalState: nil)
    }
    
    func testSendSelectedDevice(){
        connectivityViewController.bleContext = bleContext
        _ = connectivityViewController.view
        connectivityViewController.createAppliance(node: node!)
        connectivityViewController.sendSelectedDevice(0)
        doAssertion(.xctAssertNotNil, assertObject: connectivityViewController.listOfAppliance.count as AnyObject?, derivedState: nil, originalState: nil)
    }
    
    
    // Delegate methods
    
    func testNodeLost(){
        connectivityViewController.nodeLost(node!)
        doAssertion(.xctAssertNotNil, assertObject: connectivityViewController.listOfAppliance.count as AnyObject?, derivedState: nil, originalState: nil)
    }
    
    func testNodeUpdated(){
        connectivityViewController.nodeUpdated(node!)
        doAssertion(.xctAssertNotNil, assertObject: connectivityViewController.listOfAppliance.count as AnyObject?, derivedState: nil, originalState: nil)
    }
    
    func testNodeFound(){
        connectivityViewController.bleContext = bleContext
        _ = connectivityViewController.view
        connectivityViewController.nodeFound(node!)
        doAssertion(.xctAssertNotNil, assertObject: connectivityViewController.listOfAppliance.count as AnyObject?, derivedState: nil, originalState: nil)
    }
    
}
