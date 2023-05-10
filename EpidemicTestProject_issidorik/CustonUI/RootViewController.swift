//
//  RootViewController.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 10.05.2023.
//

import UIKit

final class RootViewController: UIViewController {
    
    // MARK: - Public methods
    
    func makeShow(to newViewController: UIViewController) {
        self.addChild(newViewController)
        newViewController.view.frame = self.view.bounds
        self.view.addSubview(newViewController.view)
        newViewController.didMove(toParent: self)
    }
    
    func makeSwitch(to newViewController: UIViewController) {
        self.children[0].willMove(toParent: nil)
        self.children[0].navigationController?.navigationBar.isHidden = true
        self.addChild(newViewController)
        newViewController.view.frame = self.view.bounds
        
        self.transition(
            from: self.children[0],
            to: newViewController,
            duration: 0.6,
            options: [.transitionCrossDissolve, .curveEaseOut],
            animations: {}
        ) { _ in
            self.children[0].removeFromParent()
            newViewController.didMove(toParent: self)
            }
    }
    
}
