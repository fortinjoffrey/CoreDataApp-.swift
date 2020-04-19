//
//  UINavigationController.swift
//  IntermediateTraining
//
//  Created by Joffrey Fortin on 19/04/2020.
//  Copyright © 2020 myCode. All rights reserved.
//

import UIKit

extension UINavigationController {

    func setStatusBarColor(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

}
