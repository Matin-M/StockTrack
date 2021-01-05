//
//  TabBarController.swift
//  StockTrack
//
//  Created by Matin Massoudi on 1/4/21.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
      super.viewDidLoad()
      delegate = self
    }
}

extension TabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          return false
        }

        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }

        return true
    }
}
