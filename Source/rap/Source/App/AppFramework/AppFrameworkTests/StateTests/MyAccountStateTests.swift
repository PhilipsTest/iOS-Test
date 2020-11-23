  /* Copyright (c) Koninklijke Philips N.V., 2016
   * All rights are reserved. Reproduction or dissemination
   * in whole or in part is prohibited without the prior written
   * consent of the copyright holder.
   */
  
  import XCTest
  @testable import UAPPFramework
  @testable import AppFramework
  @testable import MyAccount
  import PlatformInterfaces
  import PhilipsRegistration
  class MyAccountStateTests: XCTestCase {
    
    var myAccountState: MyAccountState?
    var returnedViewController: UIViewController?
    var uiViewController: UIViewController = UIViewController()
    var myaFactory = MyaFactoryStub()
    var myaInterface : MyaInterfaceSpy?
    
    override func setUp() {
        super.setUp()
        returnedViewController = nil
        let dependencies : UAPPDependencies = UAPPDependencies()
        dependencies.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        myaInterface = MyaInterfaceSpy(dependencies: dependencies, andSettings: nil)
        myaFactory.myaInterfaceToCreate = myaInterface
        myaInterface!.viewControllerToReturn = uiViewController
        myAccountState = MyAccountState(myaFactory: myaFactory)
    }
    
    override func tearDown() {
        myaInterface = nil
        super.tearDown()
    }

    func testMyAccountStateShouldGiveValidMYAuApp(){
        let myaState = MyAccountState()
        let myaUapp = myaState.getViewController()
        if DIUser.getInstance().userLoggedInState.rawValue == UserLoggedInState.userLoggedIn.rawValue { XCTAssertNotNil(myaUapp) }
    }
    
    func testTheSetOfTheMyAccountStateId_WhenMyAccountStateIsLoaded() {
        XCTAssertEqual(AppStates.MyAccount, myAccountState?.stateId)
    }
    
    func testReturnsThePreviouslyViewController_WithoutCreatingANewOne() {
        givenTheMyAccountViewControllerIs(uiViewController: uiViewController)
        whenGettingTheViewController()
        thenTheReturnedViewControllerIs(uiViewController: uiViewController)
    }
    
    private func givenTheMyAccountViewControllerIs(uiViewController: UIViewController?) {
        myAccountState?.myAccountViewController = uiViewController
    }
    
    private func whenGettingTheViewController() {
        returnedViewController = myAccountState?.getViewController()
    }
    
    private func thenTheReturnedViewControllerIs(uiViewController: UIViewController) {
        XCTAssertTrue(uiViewController == returnedViewController)
    }
    
    class MyaFactoryStub: MyaFactory {
        
        var myaInterfaceToCreate: MYAInterface?
        
        override func createMyaInterface() -> MYAInterface {
            return myaInterfaceToCreate!
        }
    }
    
    class MyaInterfaceSpy: MYAInterface {
        
        var sentLaunchInputs: MYALaunchInput?
        var viewControllerToReturn: UIViewController?
        
        override func instantiateViewController(_ launchInput: UAPPLaunchInput, withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
            sentLaunchInputs = (launchInput as! MYALaunchInput)
            return viewControllerToReturn
        }
    }
}
  

