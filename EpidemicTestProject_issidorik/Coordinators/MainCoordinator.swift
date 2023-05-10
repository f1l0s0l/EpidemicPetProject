//
//  MainCoordinator.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 10.05.2023.
//

import UIKit

protocol ParentCoordinator: AnyObject {
    func switchSimulationFlow(groupSize: Int, infectionFactor: Int, timeInterval: TimeInterval)
    func switchConfigurationFlow()
}

final class MainCoordinator {
    
    // MARK: - Private properties
    
    private var childCoordinators: [Coordinatable] = []
    private var rootViewController: RootViewController
    
    
    // MARK: - Life cycle
    
    init(rootViewController: RootViewController) {
        self.rootViewController = rootViewController
    }
    
    
    // MARK: - Private methods
    
    private func createConfigurationCoordinator() -> ConfigurationCoordinator {
        let configurationCoordinator = ConfigurationCoordinator(
            rootViewController: self.rootViewController,
            parentCoordinator: self
        )
        self.childCoordinators.append(configurationCoordinator)
        return configurationCoordinator
    }
    
    private func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !self.childCoordinators.contains(where: {$0 === coordinator}) else {
            return
        }
        self.childCoordinators.append(coordinator)
    }

    private func removeChildCoordinator(_ coordinator: Coordinatable) {
        self.childCoordinators.removeAll(where: {$0 === coordinator})
    }
    
}



    // MARK: - Coordinatable

extension MainCoordinator: Coordinatable {
    
    func start() {
        let configurationCoordinator = self.createConfigurationCoordinator()
        configurationCoordinator.start()
    }
}



    // MARK: - ParentCoordinator

extension MainCoordinator: ParentCoordinator {
    
    func switchSimulationFlow(groupSize: Int, infectionFactor: Int, timeInterval: TimeInterval) {
        let simulationCoordinator = SimulationCoordinator(
            rootViewController: self.rootViewController,
            parentCoordinator: self,
            groupSize: groupSize,
            infectionFactor: infectionFactor,
            timeInterval: timeInterval
        )
        
        self.childCoordinators.append(simulationCoordinator)
        simulationCoordinator.start()
        self.childCoordinators.removeFirst()
    }
    
    func switchConfigurationFlow() {
        let configurationCoordinator = self.createConfigurationCoordinator()
        configurationCoordinator.restart()
        self.childCoordinators.removeFirst()
    }
    
}
