//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Joffrey Fortin on 05/03/2018.
//  Copyright © 2018 myCode. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
        //tableView.separatorStyle = .none
        tableView.separatorColor = .white
        // The footer represents the rest of the table view. Remove lines from it
        tableView.tableFooterView = UIView() // blank UIView
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
        setupNavigationStyle()
    
        // registration of a cell class named "cellId"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
    }
    
    // function called on plus button tapped
    @objc func handleAddCompany() {
        print("Adding company...")
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
        
        
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.text = "THE COMPANY NAME"
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8 // arbitrary
    }
    
    
    func setupNavigationStyle() {
        navigationController?.navigationBar.isTranslucent = false
        
        // Creation of lightRed custom color
        
        // Nav Bar Color
        navigationController?.navigationBar.barTintColor = .lightRed
        // Setup large title
        navigationController?.navigationBar.prefersLargeTitles = true
        // Small title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        // Big title
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }
    
  

}

