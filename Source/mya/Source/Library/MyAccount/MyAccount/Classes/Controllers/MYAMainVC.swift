//
//  MYAMainVC.swift
//  MyAccount
//
//  Created by Hashim MH on 16/10/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//
import UIKit
import PhilipsUIKitDLS

class MYAMainVC: UIViewController ,MYATabControlDelegate,UITabBarControllerDelegate{
    
   
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabControl: MYATabControl!
    private var viewControllers: [UIViewController]?
    fileprivate (set) open var selectedIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = MYALocalizable(key: "MYA_My_account")
        let storyboard = UIStoryboard(name: "MYA", bundle: Bundle(for: self.classForCoder))
        let myaProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
        let myaSettingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
        let thirdTabViewController = MYAData.shared.additionalTabConfig?.viewController
        if let viewController = thirdTabViewController{
            viewControllers = [myaProfileVC,myaSettingsVC,viewController]
        } else{
            viewControllers = [myaProfileVC,myaSettingsVC]
        }
        _ = moveToController(at: selectedIndex)
        configureTabControl()
    }
    
    func configureTabControl(){
        tabControl.delegate = self
        tabControl.selectedSegmentIndex = 0
        if(tabControl.items.count < 3){
            if let tabName = MYAData.shared.additionalTabConfig?.name{
                  tabControl.items.append(tabName)
            }
        }
        guard let theme = UIDThemeManager.sharedInstance.defaultTheme else {
            return
        }
        let themeConfig = UIDThemeConfiguration(colorRange: theme.colorRange, tonalRange: theme.navigationTonalRange)
        let tabControlTheme = UIDTheme(themeConfiguration: themeConfig)
        tabControl.backgroundColor = tabControlTheme.navigationSecondaryBackground
        tabControl.indicatorColor = tabControlTheme.tabsDefaultOnIndicator
        tabControl.titleColor = tabControlTheme.tabsDefaultOnText
        tabControl.unselectedTitleColor = tabControlTheme.tabsDefaultOffText
    }
    
    func segmentedControl(_ control: MYATabControl, didSelectItemAtIndex index: Int) {
        if(tabControl.selectedSegmentIndex != self.selectedIndex){
            _ = moveToController(at: index)
        }
    }
    
     func moveToController(at index:Int) -> UIViewController?{
        if self.selectedIndex >= 0 {
            if let currentController:UIViewController = self.viewControllers?[selectedIndex]{
               currentController.removeChildViewControllerFromParent()
            }
        }
        
        guard index >= (self.viewControllers?.count)! else {
            if let controller = viewControllers?[index]{
                self.addChild(controller)
                self.containerView.addSubview(controller.view)
                self.setupConstraints(forChildController: controller)
                controller.didMove(toParent: self)
                tabControl.selectedSegmentIndex = index
                self.selectedIndex = index
                return controller
            } else{
                return nil
            }
        }
        return nil
    }
    
    func setupConstraints(forChildController controller: UIViewController) {
        let subView = controller.view
        subView?.translatesAutoresizingMaskIntoConstraints = false
        subView?.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        subView?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        subView?.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        subView?.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
}
