/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev
import PhilipsPRXClient

class ECSProductDetailsMicroServicesTests: XCTestCase {

    var sut: ECSProductDetailsMicroServices?
    override func setUp() {
        super.setUp()
        sut = ECSProductDetailsMicroServices()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func createAssetForType(type: String?) -> PRXAssetAsset {
        let asset = PRXAssetAsset()
        asset.type = type
        return asset
    }
    
    func testFilterAssetTypeCase1() {
        let assets = PRXAssetData()
        assets.assets = PRXAssetAssets()
        assets.assets?.asset = [createAssetForType(type: "RTP"),
                                      createAssetForType(type: "APP"),
                                      createAssetForType(type: "DPP"),
                                      createAssetForType(type: "MI1"),
                                      createAssetForType(type: "PID"),
                                      createAssetForType(type: "PI"),
                                      createAssetForType(type: "PP"),
                                      createAssetForType(type: "DP"),
                                      createAssetForType(type: "I1"),
                                      createAssetForType(type: "PD"),
                                      createAssetForType(type: "abc")]
        
        sut?.filterAssetType(for: assets)
        XCTAssert(assets.assets?.asset?.count == 5)
    }
    
    func testFilterAssetTypeCase2() {
        let assets = PRXAssetData()
        assets.assets = PRXAssetAssets()
        assets.assets?.asset = [createAssetForType(type: "PI"),
                                      createAssetForType(type: "PP"),
                                      createAssetForType(type: "DP"),
                                      createAssetForType(type: "I1"),
                                      createAssetForType(type: "PD"),
                                      createAssetForType(type: "abc")]
        
        sut?.filterAssetType(for: assets)
        XCTAssert(assets.assets?.asset?.count == 0)
    }
    
    func testFilterAssetTypeCase3() {
        let assets = PRXAssetData()
        assets.assets = PRXAssetAssets()
        assets.assets?.asset = [createAssetForType(type: nil)]
        
        sut?.filterAssetType(for: assets)
        XCTAssert(assets.assets?.asset?.count == 0)
    }
}
