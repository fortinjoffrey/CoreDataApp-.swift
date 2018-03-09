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
        employees.append(employee)
        tableView.reloadData()
    }    
    
}
