//
//  UIViewController+Helpers.swift
//  IntermediateTraining
//
//  Created by Joffrey Fortin on 08/03/2018.
//  Copyright © 2018 myCode. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupPlusButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }
    
    @objc func handleCancelModal() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupLightBlueBackgroundView(height: CGFloat) -> UIView {
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = .lightBlue
        
        view.addSubview(lightBlueBackgroundView)
        
        
        lightBlueBackgroundView.anchor(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: nil, leftPadding: 0, topPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: height)
        
        return lightBlueBackgroundView
    }
    
}
