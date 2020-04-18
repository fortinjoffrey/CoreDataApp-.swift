//
//  CompaniesAutoUpdateController+CreateCompany.swift
//  IntermediateTraining
//
//  Created by Joffrey Fortin on 18/04/2020.
//  Copyright © 2020 myCode. All rights reserved.
//

import UIKit

extension CompaniesAutoUpdateController: CreateCompanyControllerDelegate {
    func didEditCompany(company: Company) {
        
          let context = CoreDataManager.shared.persistentContainer.viewContext
        
        do {
             try context.save()
         } catch let saveErr {
             print("Failed to save BMW company", saveErr)
         }
        //
    }
    
    
    func didAddCompany(company: Company) {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
//        let c = Company(context: context)
//        c.employees = company.employees
//        c.founded = company.founded
//        c.imageData = company.imageData
//        c.name = company.name
        
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to save BMW company", saveErr)
        }
    }
}
