//
//  CreateEmployeeController.swift
//  IntermediateTraining
//
//  Created by Joffrey Fortin on 08/03/2018.
//  Copyright © 2018 myCode. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmploee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    var delegate: CreateEmployeeControllerDelegate?
    var company: Company?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        return textField
    }()
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        return label
    }()
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "MM/dd/yyyy"
        return textField
    }()
    
    let employeeTypeSegmentedControl: UISegmentedControl = {
        let types = [EmployeeType.Executive.rawValue,
                     EmployeeType.SeniorManagement.rawValue,
                     EmployeeType.Staff.rawValue]
        let sc = UISegmentedControl(items: types)
        sc.selectedSegmentIndex = 0
        sc.tintColor = UIColor.darkBlue
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkBlue
        navigationItem.title = "Create Employee"
        setupCancelButton()
        setupUI()
        navigationController?.setStatusBarColor(backgroundColor: .lightRed)
        navigationController?.navigationBar.backgroundColor = .lightRed
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc private func handleSave() {        
        guard let employeeName = nameTextField.text else { return }
        guard let company = self.company else { return }
        guard let birthdayText = birthdayTextField.text else { return }
        
        // perform validation step here
        if birthdayText.isEmpty {
            showError(title: "Empty Birthday", message: "You have not entered a birthday", action: "Ok")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
            showError(title: "Bad birthday date", message: "Birthday date entered not valid", action: "Ok")
            return
        }
        
        guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else { return }
        
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, employeeType: employeeType, birthday: birthdayDate, company: company)
        if let error = tuple.1 {
            // use a uialertcontroller to show error message
            print(error)
        } else {
            dismiss(animated: true, completion: {
                self.delegate?.didAddEmploee(employee: tuple.0!)
            })
        }
    }
    
    private func showError(title: String, message: String, action: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupUI() {
        _ = setupLightBlueBackgroundView(height: 150)
        
        [nameLabel, nameTextField, birthdayLabel, birthdayTextField, employeeTypeSegmentedControl].forEach { view.addSubview($0) }
           
        nameLabel.anchor(left: view.leftAnchor, top: view.topAnchor, right: nil, bottom: nil, leftPadding: 16, topPadding: 0, rightPadding: 0, bottomPadding: 0, width: 100, height: 50)
        
        nameTextField.anchor(left: nameLabel.rightAnchor, top: nameLabel.topAnchor, right: view.rightAnchor, bottom: nameLabel.bottomAnchor, leftPadding: 0, topPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        
        birthdayLabel.anchor(left: view.leftAnchor, top: nameLabel.bottomAnchor, right: nil, bottom: nil, leftPadding: 16, topPadding: 0, rightPadding: 0, bottomPadding: 0, width: 100, height: 50)
        
        birthdayTextField.anchor(left: birthdayLabel.rightAnchor, top: birthdayLabel.topAnchor, right: view.rightAnchor, bottom: birthdayLabel.bottomAnchor, leftPadding: 0, topPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
        
        employeeTypeSegmentedControl.anchor(left: view.leftAnchor, top: birthdayLabel.bottomAnchor, right: view.rightAnchor, bottom: nil, leftPadding: 16, topPadding: 0, rightPadding: 16, bottomPadding: 0, width: 0, height: 34)
    }
}
