//
//  ConfigurationCoordinator.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 10.05.2023.
//

import UIKit

protocol IConfigurationCoordinatorProtocol: AnyObject {
    func switchSimulationFlow(groupSize: Int, infectionFactor: Int, timeInterval: TimeInterval)
}

final class ConfigurationCoordinator {
    
    // MARK: - Properties
    
    private var rootViewController: RootViewController
    
    private var childCoordinators: [Coordinatable] = []
    
    private weak var parentCoordinator: ParentCoordinator?
    
    
    // MARK: - Life cycle
    
    init(rootViewController: RootViewController, parentCoordinator: ParentCoordinator?) {
        self.rootViewController = rootViewController
        self.parentCoordinator = parentCoordinator
    }
    
}



    // MARK: - Coordinatable

extension ConfigurationCoordinator: Coordinatable {
    
    func start() {
        let configurationViewModel = ConfigurationViewModel(coordinator: self)
        let configurationViewController = ConfigurationViewController(viewModel: configurationViewModel)
        
        self.rootViewController.makeShow(to: configurationViewController)
    }
    
    func restart() {
        let configurationViewModel = ConfigurationViewModel(coordinator: self)
        let configurationViewController = ConfigurationViewController(viewModel: configurationViewModel)
        
        self.rootViewController.makeSwitch(to: configurationViewController)
    }
    
}



    // MARK: - IConfigurationCoordinatorProtocol

extension ConfigurationCoordinator: IConfigurationCoordinatorProtocol {
    
    func switchSimulationFlow(groupSize: Int, infectionFactor: Int, timeInterval: TimeInterval) {
        self.parentCoordinator?.switchSimulationFlow(
            groupSize: groupSize,
            infectionFactor: infectionFactor,
            timeInterval: timeInterval
        )
    }

}
