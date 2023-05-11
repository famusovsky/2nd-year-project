//
//  CustomNavigationController.swift
//  Project
//
//  Created by Алексей Степанов on 2023-05-09.
//

import Foundation
import UIKit

class CustomNavigationController: UINavigationController {
    public var shouldAllowBack = false
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if shouldAllowBack {
            shouldAllowBack = false
            return super.popViewController(animated: animated)
        } else {
            return nil
        }
    }
}
