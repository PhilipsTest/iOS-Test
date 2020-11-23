/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra

@testable import InAppPurchaseDev

class IAPCartInterfaceTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
        let appInfra = AIAppInfra(builder: nil)
        IAPConfiguration.setIAPConfiguration("en_US", inAppInfra: appInfra!)
        IAPConfiguration.sharedInstance.baseURL = "https://www.occ.shop.philips.com"
    }
    
    override class func tearDown() {
        super.tearDown()
        Bundle.deSwizzle()
    }
    
    // MARK:
    // MARK: Add Product to cart unit tests
    // MARK:
    
    func testAddProductCartInterfaceCreation() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withQuantity(1).buildInterface()
        let httpInterface = occInterface.getInterfaceForAddProduct()
        XCTAssertNotNil(httpInterface, "***Add product interface returned is nil***")
    }
    
    func testAddProductSuccess() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withQuantity(1).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPAddProductToCart"
        
        occInterface.addProductToCart(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "***Add product returned is nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Add product error returned is nil***")
        }
    }
    
    func testAddProductFailure() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withQuantity(1).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.addProductToCart(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "***Add product returned is nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Add product error returned is nil***")
        }
    }
    
    // MARK:
    // MARK: Apply voucher unit tests
    // MARK:
    
    func testApplyVoucherInterfaceCreation() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withVoucherCode("abc").buildVoucherInterface()
        let httpInterface = occInterface.getInterfaceForApplyVoucher()
        XCTAssertNotNil(httpInterface, "***Apply Voucher interface returned is nil***")
    }
    
    func testApplyVoucherSuccess() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withVoucherCode("abc").buildVoucherInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPAddProductToCart"
        
        occInterface.applyVoucher(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "***Apply voucher returned is nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Apply voucher error returned is nil***")
        }
    }
    
    func testApplyVoucherFailure() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withVoucherCode("abc").buildVoucherInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.applyVoucher(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "***Apply voucher returned is nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Apply voucher error returned is nil***")
        }
    }
    
    
    func testAppliedVoucherListInterfaceCreation(){
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withVoucherCode("abc").buildVoucherInterface()
        let httpInterface = occInterface.getInterfaceForAppliedVoucherList()
        XCTAssertNotNil(httpInterface, "***Applied Voucher List interface returned is nil***")
    }
    
    func testAppliedVoucherListSuccess() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withVoucherCode("abc").buildVoucherInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPAddProductToCart"
        
        occInterface.getAppliedVoucherList(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "***Applied voucher list returned is nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Applied voucher list error returned is nil***")
        }
    }
    
    func testAppliedVoucherListFailure() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withVoucherCode("abc").buildVoucherInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.getAppliedVoucherList(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "***Appied voucher list returned is nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Applied voucher list error returned is nil***")
        }
    }
    
    func testRemovedVoucherInterfaceCreation(){
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withVoucherCode("abc").buildVoucherInterface()
        let httpInterface = occInterface.getInterfaceForRemoveVoucher()
        XCTAssertNotNil(httpInterface, "***Removed Voucher  interface returned is nil***")
    }
    
    func testRemovedVoucherSuccess() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withVoucherCode("abc").buildVoucherInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPAddProductToCart"
        
        occInterface.removeVoucher(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "***Removed voucher returned is nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Removed voucher  error returned is nil***")
        }
    }
    
    func testRemovedVoucherFailure() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withVoucherCode("abc").buildVoucherInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.removeVoucher(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "***Removed voucher  returned is nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Removed voucher  error returned is nil***")
        }
    }
    // MARK:
    // MARK: Update cart unit tests
    // MARK:
    
    func testUpdateCartInterfaceCreation() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = occInterface.getInterfaceForUpdateCart()
        XCTAssertNotNil(httpInterface, "***Update cart interface returned is nil***")
    }
    
    func testUpdateCartSuccess() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPUpdateProductCart"
        
        occInterface.updateCart(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "***Update cart returned is nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Update cart error returned is nil***")
        }
    }
    
    func testUpdateCartFailure() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.updateCart(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "***Update cart returned is nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Update cart error returned is nil***")
        }
    }
    
    // MARK:
    // MARK: Create cart unit tests
    // MARK:
    
    func testCreateCartInterfaceCreation() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = occInterface.getInterfaceForCreateCart()
        XCTAssertNotNil(httpInterface, "***Create cart interface returned is nil***")
    }
    
    func testCreateCartSuccess() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCCreateCart"
        
        occInterface.createNewCart(httpInterface, completionHandler: { (withObject) in
            XCTAssertNotNil(withObject, "***Create cart returned nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Create cart error returned is nil***")
        }
    }
    
    func testCreateCartFailure() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCCreateCart"
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.createNewCart(httpInterface, completionHandler: { (withObject) in
            XCTAssertNotNil(withObject, "***Create cart returned nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Create cart error returned is nil***")
        }
    }
    
    // MARK:
    // MARK: Delete cart unit tests
    // MARK:
    
    func testDeleteCartInterfaceCreation() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = occInterface.getInterfaceForDeleteCart()
        XCTAssertNotNil(httpInterface, "***Delete cart interface returned is nil***")
    }
    
    func testDeleteCartSuccess() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        
        occInterface.deleteCart(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "***Delete cart returned nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Delete cart error returned is nil***")
        }
    }
    
    func testDeleteCartFailure() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = ""
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.deleteCart(httpInterface, completionHandler: { (inSuccess) in
            XCTAssertNotNil(inSuccess, "***Delete cart returned nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Delete cart error returned is nil***")
        }
    }
    
    // MARK:
    // MARK: Get cart unit tests
    // MARK:
    
    func testGetCartInterfaceCreation() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = occInterface.getInterfaceForGetCarts()
        XCTAssertNotNil(httpInterface, "***Get cart interface returned is nil***")
    }
    
    func testGetCartSuccess() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCGetCarts"
        
        occInterface.getCartsForUser(httpInterface, completionHandler: { (withObjects) in
            XCTAssertNotNil(withObjects, "***Get cart returned nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Get cart error returned is nil***")
        }
    }
    
    func testGetCartFailure() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCGetCarts"
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.getCartsForUser(httpInterface, completionHandler: { (withObjects) in
            XCTAssertNotNil(withObjects, "***Get cart returned nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Get cart error returned is nil***")
        }
    }
    
    // MARK:
    // MARK: Get cart Details unit tests
    // MARK:
    
    func testGetCartDetailInterfaceCreation() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = occInterface.getInterfaceForGetCartDetails()
        XCTAssertNotNil(httpInterface, "***Get cart details interface returned is nil***")
    }
    
    func testGetCartDetailSuccess() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCGetCartDetails"
        
        occInterface.getCartDetails(httpInterface, completionHandler: { (inSuccess, withObject) in
            XCTAssertNotNil(withObject, "***Get cart detail returned nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Get cart detail error returned is nil***")
        }
    }
    
    func testGetCartDetailFailure() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPOCCGetCartDetails"
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.getCartDetails(httpInterface, completionHandler: { (inSuccess, withObject) in
            XCTAssertNotNil(withObject, "***Get cart detail returned nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Get cart detail error returned is nil***")
        }
    }
    
    // MARK:
    // MARK: Fetch Product Information unit tests
    // MARK:
    
    func testFetchProductInfoInterfaceCreation() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        var httpInterface = occInterface.getInterfaceForFetchInformationForProduct(false)
        XCTAssertNil(httpInterface, "***Fetch product info interface returned is not nil***")
        httpInterface = occInterface.getInterfaceForFetchInformationForProduct(true)
        XCTAssertNotNil(httpInterface, "***Fetch product info interface returned is nil***")
    }
    
    func testFetchProductInfoSuccess() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPFetchInfoForProductResponse"
        
        occInterface.fetchInformationForProduct(httpInterface, completionHandler: { (withProduct) in
            XCTAssertNotNil(withProduct, "***Fetch product info returned is nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Fetch product info error returned is nil***")
        }
        occInterface.fetchInformationForProduct(nil, completionHandler: { (withProduct) in
            XCTAssertNotNil(withProduct, "***Fetch product info returned is nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Fetch product info error returned is nil***")
        }
    }
    
    func testFetchProductInfoFailure() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPFetchInfoForProductResponse"
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.fetchInformationForProduct(httpInterface, completionHandler: { (withProduct) in
            XCTAssertNotNil(withProduct, "***Fetch product info returned is nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Fetch product info error returned is nil***")
        }
    }
    
    func testFetchProductInfoForNonHybris(){
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        occInterface.fetchInformationForProduct(nil, completionHandler: { (withProduct) in
            XCTAssertNotNil(withProduct, "***Fetch product info returned is nil***")
        }) { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Fetch product info error returned is nil***")
        }
    }
    
    // MARK:
    // MARK: Fetch All Products unit tests
    // MARK:
    
    func testFetchAllProductsInterfaceCreation() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        var httpInterface = occInterface.getInterfaceForFetchAllProducts(false)
        XCTAssertNil(httpInterface, "interface is not nil")
        
        httpInterface = occInterface.getInterfaceForFetchAllProducts(true)
        XCTAssertNotNil(httpInterface, "interface is nil")
    }
    
    func testFetchAllProductsSuccess() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPProductSampleResponse"
        
        occInterface.fetchAllProducts(httpInterface, completionHandler: { (withProducts, paginationDict) in
            XCTAssertNotNil(withProducts, "***Fetch all products returned is nil***")
        }, failureHandler: { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Fetch all products error returned is nil***")
        })
    }
    
    func testFetchAllProductsFailure() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        let httpInterface = IAPBaseHTTPInterfaceTest(request: "", httpHeaders: nil, bodyParameters: nil)
        httpInterface.jsonNameToUse = "IAPProductSampleResponse"
        httpInterface.isErrorToBeInvoked = true
        
        occInterface.fetchAllProducts(httpInterface, completionHandler: { (withProducts, paginationDict) in
            XCTAssertNotNil(withProducts, "***Fetch all products returned is nil***")
        }, failureHandler: { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Fetch all products error returned is nil***")
        })
    }
    
    func testFetchAllProductsForNonHybris(){
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID:"12345")!.withProductCode("12345").withEntryNumber(0).withQuantity(2).buildInterface()
        occInterface.fetchAllProducts(nil, completionHandler: { (withProducts, paginationDict) in
            XCTAssertNotNil(withProducts, "***Fetch all products returned is nil***")
        }, failureHandler: { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Fetch all products error returned is nil***")
        })
        
    }
    
    // MARK:
    // MARK: Handle OCC Response unit test
    // MARK:
    
    func testHandleOCCResponseFailure(){
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID: "12345")?.buildInterface()
        occInterface?.handleOCCResponse(["statusCode" : "MockError" as AnyObject], successHandler: { (isSuccess) in
            XCTAssertNotNil(isSuccess, "Success returned is nil")
        }, failureHandler: { (inError:NSError) -> () in
            XCTAssertNotNil(inError,"***Error returned is nil***")
        })
    }
    
    func testGetCartParameterDict() {
        let occInterface = IAPOCCCartInterfaceBuilder(inUserID: "12345")?.buildInterface()
        let oauth = IAPOAuthInfo()
        oauth.refreshToken = "12345"
        oauth.accessToken  = "54321"
        oauth.tokenType    = "Bearer"
        
        let dictionary = occInterface?.getParameterDictForCartDownloads(oauth)
        XCTAssertNotNil(dictionary,"Dictionary returned is empty")
        
        let value = dictionary?[IAPConstants.IAPOCCHeader.kAuthorizationKey]
        XCTAssert(value == "Bearer 54321","Value returned is not matching")
    }
    
}

