//
//  CoreDataManager.swift
//  IntermediateTraining
//
//  Created by Joffrey Fortin on 06/03/2018.
//  Copyright © 2018 myCode. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager() // will live forever
    let persistentContainer: NSPersistentContainer = {
    
        let container = NSPersistentContainer(name: "IntermediateTrainingModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
}
