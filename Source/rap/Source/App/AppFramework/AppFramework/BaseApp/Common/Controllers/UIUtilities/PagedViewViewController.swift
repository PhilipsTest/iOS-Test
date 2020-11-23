/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit

protocol PagedViewViewControllerDelegate: class {

    func pagedViewViewController(_ pagedViewViewController: PagedViewViewController,
                                   didUpdatePageCount count: Int)
    func pagedViewViewController(_ pagedViewViewController: PagedViewViewController,
                                   didUpdatePageIndex index: Int)
}

class PagedViewViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    weak var pageDelegate: PagedViewViewControllerDelegate?
    
    public var plistOptionsKey: String? { return nil }
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return self.createChildViewControllers()
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = self
        delegate = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }

        pageDelegate?.pagedViewViewController(self, didUpdatePageCount: orderedViewControllers.count)
    }

    func createChildViewControllers() -> [UIViewController] {
        guard let plistKey = plistOptionsKey else {
            return []
        }

        let plistViewOptions = Utilites.readDataFromFile(plistKey) as! [[String : AnyObject]]
        return plistViewOptions.map { (viewOptions) -> UIViewController in
            return createChildViewController(viewOptions)
        }
    }

    func createChildViewController(_ viewOptions: [String : AnyObject]) -> UIViewController {
        return UIViewController() // empty instance, should be overridden in derived classes
    }
    
    //MARK: Navigation methods
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self, viewControllerAfter: visibleViewController)
        {
            scrollToViewController(nextViewController)
        }
    }
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.firstIndex(of: firstViewController) {
            let direction: UIPageViewController.NavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToViewController(nextViewController, direction: direction)
        }
    }
 
    fileprivate func scrollToViewController(_ viewController: UIViewController,
                                            direction: UIPageViewController.NavigationDirection = .forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
                            // Setting the view controller programmatically does not fire
                            // any delegate methods, so we have to manually notify the
                            // 'pageDelegate' of the new index.
                            self.notifyAboutNewIndex()
        })
    }
    
    fileprivate func notifyAboutNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.firstIndex(of: firstViewController) {
            
            pageDelegate?.pagedViewViewController(self, didUpdatePageIndex: index)
        }
    }
    
    //MARK: UIPageViewControllerDataSource methods

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    //MARK: UIPageViewControllerDelegate methods
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        notifyAboutNewIndex()
    }
}
