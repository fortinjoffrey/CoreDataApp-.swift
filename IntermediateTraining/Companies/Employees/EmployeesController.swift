//
//  EmployeesController.swift
//  IntermediateTraining
//
//  Created by Joffrey Fortin on 08/03/2018.
//  Copyright © 2018 myCode. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController {
    
    var company: Company?
    var employees = [Employee]()
    let cellId = "cellId"
    
    
    
    var shortNameEmployees = [Employee]()
    var longNameEmployees = [Employee]()
    var reallyLongNameEmployees = [Employee]()
    
    var allEmployees = [[Employee]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = company?.name
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        fetchEmployees()
    }
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
//        self.employees = companyEmployees
        
        shortNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count < 6
            }
            return false
        })
        
        longNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count > 6 && count < 9
            }
            return false
        })
        
        reallyLongNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count > 9
            }
            return false
        })
        
        allEmployees = [shortNameEmployees, longNameEmployees, reallyLongNameEmployees]
        
    }
    
    @objc private func handleAdd() {
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
    }
}
