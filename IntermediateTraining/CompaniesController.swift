//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Joffrey Fortin on 05/03/2018.
//  Copyright © 2018 myCode. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    var companies = [Company]()

    
    private func fetchCompanies() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach({ (company) in
                print(company.name ?? "")
            })
            
            self.companies = companies
            self.tableView.reloadData()
            
        } catch let fetchErr {
            print("Failed to fetch companies:", fetchErr)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCompanies()
        
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
        //tableView.separatorStyle = .none
        tableView.separatorColor = .white
        // The footer represents the rest of the table view. Remove lines from it
        tableView.tableFooterView = UIView() // blank UIView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
        // registration of a cell class named "cellId"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
    }
    
    @objc func handleAddCompany() {
        
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        createCompanyController.delegate = self
        
        present(navController, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let company = companies[indexPath.row]
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let company = self.companies[indexPath.row]
            print("Attempting to delete company:", company.name ?? "")
            
            // remove the company from our table view
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            // delete the company from Core Data
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company)
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to delete company:", saveErr)
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (_, indexPath) in
            print("Editing company..")
        }
        
        return [deleteAction, editAction]
    }
    
    

}

