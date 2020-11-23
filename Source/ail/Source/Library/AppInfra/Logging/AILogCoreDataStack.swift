//
//  AILogCoreDataStack.swift
//  AppInfra
//
//  Created by Philips on 26/04/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import Foundation
import CoreData

@objc public class AILogCoreDataStack: NSObject {
    
    private lazy var persistentContainer: NSPersistentContainer = {
         var container = NSPersistentContainer(name: Constants.momdName)
        if let modelURL = Bundle(for: type(of: self)).url(forResource: Constants.momdName, withExtension:"momd"){
            if let mom = NSManagedObjectModel(contentsOf: modelURL){
                 container = NSPersistentContainer(name: Constants.momdName, managedObjectModel: mom)
                container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                    if let error = error as NSError? {
                        fatalError("Unresolved error \(error), \(error.userInfo)")
                    }
                })
            }
        }
        return container
    }()
    
   @objc public var managedObjectContext: NSManagedObjectContext?
   @objc static public let shared = AILogCoreDataStack()
    
    // MARK: -
    
    
    // Initialization
    
    private override init() {
        super.init()
        managedObjectContext = persistentContainer.newBackgroundContext()
        managedObjectContext?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
   @objc func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    @objc public func perform(_ block: @escaping () -> Void) {
        managedObjectContext?.perform(block)
    }

}
