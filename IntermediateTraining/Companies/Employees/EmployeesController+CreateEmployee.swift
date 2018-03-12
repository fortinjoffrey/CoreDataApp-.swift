//
//  EmployeesController+CreateEmployee.swift
//  IntermediateTraining
//
//  Created by Joffrey Fortin on 09/03/2018.
//  Copyright © 2018 myCode. All rights reserved.
//

import UIKit

extension EmployeesController: CreateEmployeeControllerDelegate {
    
    func didAddEmploee(employee: Employee) {
//        fetchEmployees()
//        tableView.reloadData()
        
        guard let section = employeeTypes.index(of: employee.type!) else { return }
        let row = allEmployees[section].count
        let insertionIndexPath = IndexPath(row: row, section: section)
        
        allEmployees[section].append(employee)
        
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }    
    
}
