//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Joffrey Fortin on 05/03/2018.
//  Copyright © 2018 myCode. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companies = CoreDataManager.shared.fetchCompanies()
        
        view.backgroundColor = UIColor.white        
        navigationItem.title = "Companies"
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        // The footer represents the rest of the table view. Remove lines from it
        tableView.tableFooterView = UIView() // blank UIView
        
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Nested Updates", style: .plain, target: self, action: #selector(doNestedUpdates))
        ]
        
        
        // registration of a cell class named "cellId"
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
    }
    
    @objc private func handleReset() {
        print("Attempting to delete all core data obnects")
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            
            var indexPathsToRemove = [IndexPath]()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
        } catch let delErr {
            print("Failed to delete objects for Core Data:", delErr)
        }
    }
    
    @objc func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        present(navController, animated: true, completion: nil)
    }
    
    @objc private func doWork() {
        print("Trying to do work...")
        // GCD - Grand Central Dispatch
        // to perform task in background
        DispatchQueue.global(qos: .background).async {
        }
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
            (0...5).forEach { (value) in
                let company = Company(context: backgroundContext)
                print(value)
                company.name = String(value)
            }
            
            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
            } catch let err {
                print("Failed to save:", err)
            }
        })
    }
    
    
    // let's do some tricky updates with core data
    @objc private func doUpdates() {
        print("Trying to update companies on a backfgorund context")
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            do {
                let companies = try backgroundContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "A: \(company.name ?? "")"
                })
                
                do {
                    try backgroundContext.save()
                } catch let saveErr {
                    print("Failed t osave on background:", saveErr)
                }
            } catch let err {
                print("Failed t ofetch companies on background:", err)
            }
            
        }
    }
    
    @objc private func doNestedUpdates() {
        print("Trying to perform nested updates")
        
        DispatchQueue.global(qos: .background).async {
            // we'll try to perform our updates
            
            // we'll first construct a custom MOC
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            // execute updates on privateContext now
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            
            do {
                let companies = try privateContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "D: \(company.name ?? "")"
                })
                
                do {
                    try privateContext.save()
                    // after save succeed
                    DispatchQueue.main.async {
                        do {
                            let context = CoreDataManager.shared.persistentContainer.viewContext
                            if context.hasChanges {
                                try context.save()
                            }                            
                            self.tableView.reloadData()
                        } catch let finalSaveErr {
                            print("Failed to save main context:", finalSaveErr)
                        }
                    }
                } catch let saveErr {
                    print("Failed to save on private context:", saveErr)
                }
                
            } catch let fetchErr {
                print("Failed to fetch on private context:", fetchErr)
            }
        }
        
    }
    
}
