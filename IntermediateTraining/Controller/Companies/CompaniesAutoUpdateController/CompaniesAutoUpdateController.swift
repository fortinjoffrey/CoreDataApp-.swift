//
//  CompaniesAutoUpdateController.swift
//  IntermediateTraining
//
//  Created by Joffrey Fortin on 12/03/2018.
//  Copyright © 2018 myCode. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedResultsControler: NSFetchedResultsController<Company> = {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true) ] // if true sorted A-Z
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)

        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch let err {
            print(err)
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        
        navigationController?.setStatusBarColor(backgroundColor: .lightRed)
        navigationItem.title = "Company Auto Updates"
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Delete all", style: .plain, target: self, action: #selector(handleDeleteAll))
        ]
        
        
        navigationController?.navigationBar.backgroundColor = .lightRed
        
             setupPlusButtonInNavBar(selector: #selector(handleAdd))
        
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .white
        self.refreshControl = refreshControl        
    }
    
    @objc func handleRefresh() {
        Service.shared.downloadCompaniesFromServer()
        refreshControl?.endRefreshing()
    }
    
    let cellId = "cellId"
    
    @objc private func handleAdd() {
        
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        
        navController.modalPresentationStyle = .overCurrentContext
        
        present(navController, animated: true, completion: nil)
        
        
    }
    
    @objc private func handleDeleteAll() {
        let request: NSFetchRequest<Company> = Company.fetchRequest()
//        request.predicate = NSPredicate(format: "name CONTAINS %@", "B")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let companiesWithB = try? context.fetch(request)
        companiesWithB?.forEach { (company) in
            context.delete(company)
        }
        try? context.save()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsControler.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.text = fetchedResultsControler.sectionIndexTitles[section]
        label.backgroundColor = UIColor.lightBlue
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsControler.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompanyCell
        
        let company = fetchedResultsControler.object(at: indexPath)
        cell.company = company
        return cell
    }
  
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeesListController = EmployeesController()
        employeesListController.company = fetchedResultsControler.object(at: indexPath)
        navigationController?.pushViewController(employeesListController, animated: true)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    
    // Provided by Apple
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteHandlerFunction)
              deleteAction.backgroundColor = UIColor.lightRed
              
              let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
              editAction.backgroundColor = UIColor.darkBlue
              
              return [deleteAction, editAction]
    }
    
    private func deleteHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        
         let company = fetchedResultsControler.object(at: indexPath)
        
                let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(company)
        
           try? context.save()
        
    }
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        
        let editCompanyController = CreateCompanyController()
        editCompanyController.delegate = self
        
        let company = fetchedResultsControler.object(at: indexPath)
        
        editCompanyController.company = company
        
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        
        navController.modalPresentationStyle = .overCurrentContext

        present(navController, animated: true, completion: nil)
        
    }
    
}
