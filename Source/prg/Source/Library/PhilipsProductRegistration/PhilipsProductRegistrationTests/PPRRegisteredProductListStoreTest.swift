//
//  PPRRegisteredProductListStoreTest.swift
//  PhilipsProductRegistration
//

// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
import PhilipsRegistration
import PhilipsPRXClient

@testable import PhilipsProductRegistrationDev

//class PPRRegisteredProductListStoreTest: PPRBaseClassTests {
//
//    func testGetListFromStore() {
//        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
//        let list = PPRRegisteredProductListStore().getProductListForUser(uuid: nil)
//        XCTAssertNil(list)
//    }
//    
//    func testSaveProduct() {
//        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
//        let productStore = PPRRegisteredProductListStore()
//        let product = self.fakeRegisteredProduct(PPRTestConstants.RegistredCtn,
//                                                 serialNum: PPRTestConstants.RegistredSerialNum,
//                                                 date: nil,
//                                                 sector: DEFAULT,
//                                                 catalog: CONSUMER,
//                                                 error: nil,
//                                                 endWarrenty: Date(),
//                                                 uuid: nil,
//                                                 locale: nil,
//                                                 emailStatus: "Email sending was successful")
//        productStore.registeredProduct(product: product)
//        
//        let productTwo = self.fakeRegisteredProduct(PPRTestConstants.RegistredCtn,
//                                                 serialNum: PPRTestConstants.RegistredSerialNum,
//                                                 date: nil,
//                                                 sector: DEFAULT,
//                                                 catalog: CONSUMER,
//                                                 error: nil,
//                                                 endWarrenty: Date(),
//                                                 uuid: "ABC",
//                                                 locale: nil,
//                                                 emailStatus: "Email sending was not successful")
//        productStore.registeredProduct(product: productTwo)
//        
//        let productThree = self.fakeRegisteredProduct(PPRTestConstants.RegistredCtn,
//                                                 serialNum: PPRTestConstants.RegistredSerialNum,
//                                                 date: nil,
//                                                 sector: DEFAULT,
//                                                 catalog: CONSUMER,
//                                                 error: nil,
//                                                 endWarrenty: Date(),
//                                                 uuid: "DEF",
//                                                 locale: nil,
//                                                 emailStatus: "Email sending was not successful")
//        productStore.registeredProduct(product: productThree)
//        
//        let list = productStore.getProductListForUser(uuid: nil)
//        XCTAssertNotNil(list)
//        XCTAssertTrue((list?.isEmpty)!)
//        XCTAssertFalse(productStore.isProductAlreadyRegistered(product: product, list: list!).isReigistered)
//    }
//    
//    func testGetListWithOutUUID()  {
//        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
//        let productList = self.fakeProductList()
//        let productStore = PPRRegisteredProductListStore()
//        productStore.updateProductList(productList, userUUID: nil)
//        _ = productStore.getProductListForUser(uuid: nil)
//       // XCTAssertTrue(list?.count == 3)
//    }
//    
//    func testGetListWithUUID()  {
//        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
//        let invalidDateError = PPRErrorHelper().createCustomError(error:
//            
//            PPRError.INVALID_PURCHASE_DATE)
//        let noInternetError = PPRErrorHelper().createCustomError(error: PPRError.NO_INTERNET_CONNECTION)
//        let pendingProduct = self.fakeRegisteredProduct(PPRTestConstants.RegistredCtn, serialNum: PPRTestConstants.RegistredSerialNum, date: nil, sector: DEFAULT, catalog: CONSUMER, error: invalidDateError, endWarrenty: nil, uuid: "ABD", locale: "en_GB_CONSUMER", emailStatus: "Email sending was not successful")
//        let failedProduct = self.fakeRegisteredProduct(PPRTestConstants.RegistredCtn, serialNum: "1332", date: nil, sector: B2C, catalog: CONSUMER, error: noInternetError, endWarrenty: nil, uuid: "ABC", locale: "en_US_CONSUMER", emailStatus: "Email sending was not successful")
//        let registeredProduct = self.fakeRegisteredProduct(PPRTestConstants.ctn, serialNum: "1234", date: nil, sector: B2C, catalog: CONSUMER, error: nil, endWarrenty: nil, uuid: "ABC", locale: "en_US_CONSUMER", emailStatus: "Email sending was successful")
//        let productStore = PPRRegisteredProductListStore()
//        productStore.updateProductList([pendingProduct,failedProduct,registeredProduct], userUUID: nil)
//        let listForABCUser = productStore.getProductListForUser(uuid: "ABC")
//        XCTAssertTrue(listForABCUser?.count == 2)
//        //XCTAssertTrue(productStore.isProductAlreadyRegistered(product: failedProduct, list: listForABCUser!).isReigistered)
//        //XCTAssertTrue(productStore.isProductAlreadyRegistered(product: registeredProduct, list: listForABCUser!).isReigistered)
//        _ = productStore.getProductListForUser(uuid: "ABD")
//        //XCTAssertTrue(listForABDUser?.count == 1)
//        //XCTAssertTrue(productStore.isProductAlreadyRegistered(product: pendingProduct, list: listForABDUser!).isReigistered)
//    }
//    
//    func  testPendingListEmpty() {
//        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
//        let productStore = PPRRegisteredProductListStore()
//        XCTAssertNil(productStore.getPendingAndFailedProductListForUser(uuid: nil))
//    }
//    
//    func  testPendingList() {
//        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
//        let productList = self.fakeProductList()
//        let productStore = PPRRegisteredProductListStore()
//        productStore.updateProductList(productList, userUUID: nil)
//        let pendingList = productStore.getPendingAndFailedProductListForUser(uuid: nil)
//        XCTAssertNotNil(pendingList)
//        XCTAssertTrue(pendingList?.count==2)
//    }
//
//    func  testPendingListProductsWithInvalidSerialNumber() {
//        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
//        let invalidSerialNumError = PPRErrorHelper().createCustomError(error: PPRError.CTN_NOT_EXIST)
//        let invalidSerialNumProduct = self.fakeRegisteredProduct(PPRTestConstants.ctn, serialNum: "4567", date: nil, sector: B2C, catalog: CARE, error: invalidSerialNumError, endWarrenty: nil, uuid: "ABC", locale: nil, emailStatus: nil)
//        var productList = self.fakeProductList()
//        productList.append(invalidSerialNumProduct)
//        let productStore = PPRRegisteredProductListStore()
//        productStore.updateProductList(productList, userUUID: nil)
//        let pendingList = productStore.getPendingAndFailedProductListForUser(uuid: "ABC")
//        XCTAssertNotNil(pendingList)
//        XCTAssertTrue(pendingList?.count==2)
//    }
//    
//    func  testPendingListProductsWithInvalidSerialNumberAndCNTnotfound() {
//        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
//        let invalidSerialNumError = PPRErrorHelper().createCustomError(error: PPRError.INVALID_SERIAL_NUMBER)
//        let ctnNotFoundError = PPRErrorHelper().createCustomError(error: PPRError.CTN_NOT_EXIST)
//        let invalidSerialNumProduct = self.fakeRegisteredProduct(PPRTestConstants.ctn, serialNum: "4567", date: nil, sector: B2C, catalog: CARE, error: invalidSerialNumError, endWarrenty: nil, uuid: "ABC", locale: nil, emailStatus: nil)
//        let ctnNotFoundProduct = self.fakeRegisteredProduct(PPRTestConstants.ctn, serialNum: "891", date: nil, sector: B2C, catalog: CARE, error: ctnNotFoundError, endWarrenty: nil, uuid: "ABC", locale: nil, emailStatus: nil)
//        var productList = self.fakeProductList()
//        productList.append(invalidSerialNumProduct)
//        productList.append(ctnNotFoundProduct)
//        let productStore = PPRRegisteredProductListStore()
//        productStore.updateProductList(productList, userUUID:  nil)
//        let pendingList = productStore.getPendingAndFailedProductListForUser(uuid: "ABC")
//        XCTAssertNotNil(pendingList)
//        XCTAssertTrue(pendingList?.count==2)
//    }
//    
//    func  testPendingListProductsWithInvalidSerialNumberRequiredPurchaseDateAndCNTnotfound() {
//        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
//        let invalidSerialNumAndReqPurchaseDateError = PPRErrorHelper().createCustomError(error: PPRError.INVALID_SERIAL_NUMBER_AND_PURCHASE_DATE)
//        let ctnNotFoundError = PPRErrorHelper().createCustomError(error: PPRError.CTN_NOT_EXIST)
//        let invalidSerialNumProduct = self.fakeRegisteredProduct(PPRTestConstants.ctn, serialNum: "4567", date: nil, sector: B2C, catalog: CARE, error: invalidSerialNumAndReqPurchaseDateError, endWarrenty: nil, uuid: "ABC", locale: nil, emailStatus: nil)
//        let ctnNotFoundProduct = self.fakeRegisteredProduct(PPRTestConstants.ctn, serialNum: "891", date: nil, sector: B2C, catalog: CARE, error: ctnNotFoundError, endWarrenty: nil, uuid: "ABC", locale: nil, emailStatus: nil)
//        var productList = self.fakeProductList()
//        productList.append(invalidSerialNumProduct)
//        productList.append(ctnNotFoundProduct)
//        let productStore = PPRRegisteredProductListStore()
//        productStore.updateProductList(productList, userUUID: nil)
//        let pendingList = productStore.getPendingAndFailedProductListForUser(uuid: "ABC")
//        XCTAssertNotNil(pendingList)
//        XCTAssertTrue(pendingList?.count==2)
//    }
//    
//    func  testPendingListProductsWithRequiredPurchaseDateAndCNTnotfound() {
//        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
//        let reqPurchaseDateError = PPRErrorHelper().createCustomError(error: PPRError.REQUIRED_PURCHASE_DATE)
//        let ctnNotFoundError = PPRErrorHelper().createCustomError(error: PPRError.CTN_NOT_EXIST)
//        let invalidSerialNumProduct = self.fakeRegisteredProduct(PPRTestConstants.ctn, serialNum: "4567", date: nil, sector: B2C, catalog: CARE, error: reqPurchaseDateError, endWarrenty: nil, uuid: "ABC", locale: nil, emailStatus: nil)
//        let ctnNotFoundProduct = self.fakeRegisteredProduct(PPRTestConstants.ctn, serialNum: "891", date: nil, sector: B2C, catalog: CARE, error: ctnNotFoundError, endWarrenty: nil, uuid: "ABC", locale: nil, emailStatus: nil)
//        var productList = self.fakeProductList()
//        productList.append(invalidSerialNumProduct)
//        productList.append(ctnNotFoundProduct)
//        let productStore = PPRRegisteredProductListStore()
//        productStore.updateProductList(productList, userUUID: nil)
//        let pendingList = productStore.getPendingAndFailedProductListForUser(uuid: "ABC")
//        XCTAssertNotNil(pendingList)
//        XCTAssertTrue(pendingList?.count==3)
//    }
//    
//    func testRemoveProduct() {
//        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
//        let noInternetError = PPRErrorHelper().createCustomError(error: PPRError.NO_INTERNET_CONNECTION)
//        let pendingProduct = self.fakeRegisteredProduct(PPRTestConstants.RegistredCtn, serialNum: PPRTestConstants.RegistredSerialNum, date: nil, sector: B2C, catalog: CONSUMER, error: noInternetError, endWarrenty: nil, uuid: nil, locale: nil, emailStatus: "Email sending was successful")
//        let productStore = PPRRegisteredProductListStore()
//        productStore.updateProductList([pendingProduct], userUUID: nil)
//        let list = productStore.getProductListForUser(uuid: nil)
//        XCTAssertTrue(list?.count==1)
//        productStore.removeProduct(pendingProduct)
//        let afterRemoveList = productStore.getProductListForUser(uuid: nil)
//        XCTAssertTrue(afterRemoveList?.count==0)
//    }
//    
//    func testRemovedProductsUpdateInCatch() {
//        PPRStorageProvider.removeFile(PPRStorageProviderConst.kStorageIndex)
//        let userUUID = "XYZ"
//        let productList = self.fakeProductList(userUUID)
//        let productStore = PPRRegisteredProductListStore()
//        productStore.updateProductList(productList, userUUID: userUUID)
//        let regProduct1 = self.fakeRegisteredProduct(PPRTestConstants.RegistredCtn, serialNum: "999", date: nil, sector: B2C, catalog: CONSUMER, error: nil, endWarrenty: nil, uuid: userUUID, locale: nil, emailStatus: "Email sending was successful")
//        let regProduct2 = self.fakeRegisteredProduct(PPRTestConstants.RegistredCtn, serialNum: "998", date: nil, sector: B2C, catalog: CONSUMER, error: nil, endWarrenty: nil, uuid: userUUID, locale: nil, emailStatus: "Email sending was successful")
//        productStore.updateProductList([regProduct1,regProduct2], userUUID: userUUID)
//        let pendingList = productStore.getProductListForUser(uuid: userUUID)
//        XCTAssertNotNil(pendingList)
//        XCTAssertTrue(pendingList?.count==5)
//    }
//    
//    func fakeProductList(_ uuid: String? = nil) -> [PPRRegisteredProduct] {
//        let invalidDateError = PPRErrorHelper().createCustomError(error: PPRError.INVALID_PURCHASE_DATE)
//        let noInternetError = PPRErrorHelper().createCustomError(error: PPRError.NO_INTERNET_CONNECTION)
//        let pendingProduct = self.fakeRegisteredProduct(PPRTestConstants.RegistredCtn, serialNum: PPRTestConstants.RegistredSerialNum, date: nil, sector: B2C, catalog: CONSUMER, error: invalidDateError, endWarrenty: nil, uuid: uuid, locale: nil, emailStatus: "Email sending was not successful")
//        let failedProduct = self.fakeRegisteredProduct(PPRTestConstants.RegistredCtn, serialNum: nil, date: nil, sector: B2C, catalog: CONSUMER, error: noInternetError, endWarrenty: nil, uuid: uuid, locale: nil, emailStatus: "Email sending was not successful")
//        let registeredProduct = self.fakeRegisteredProduct(PPRTestConstants.ctn, serialNum: "1234", date: nil, sector: B2C, catalog: CONSUMER, error: nil, endWarrenty: nil, uuid: uuid, locale: nil, emailStatus: "Email sending was successful")
//        return[registeredProduct,pendingProduct,failedProduct]
//    }
//    
//    fileprivate func fakeRegisteredProduct(_ ctn: String?,
//                                       serialNum: String!,
//                                       date: Date!,
//                                       sector: Sector,
//                                       catalog: Catalog,
//                                       error:NSError?,
//                                       endWarrenty: Date?,
//                                       uuid: String!,
//                                       locale: String!,
//                                       emailStatus: String!) -> PPRRegisteredProduct
//    {
//        let product = PPRRegisteredProduct(ctn: ctn!, sector: sector, catalog: catalog)
//        product.purchaseDate = date
//        product.serialNumber = serialNum
//        product.error = error
//        product.endWarrantyDate = endWarrenty
//        product.userUuid = uuid
//        product.registeredLocale = locale
//        product.emailStatus = emailStatus
//        return product
//    }
//    
//    func testMigrateProductListData() {
//        let productStore = PPRRegisteredProductListStore()
//        productStore.migrateProductListData()
//        let data = productStore.fetchChachedDataThatNeedsToBeMigrated()
//        XCTAssertNil(data)
//    }
//}
