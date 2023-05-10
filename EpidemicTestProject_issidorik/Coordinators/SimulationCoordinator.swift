//
//  SimulationCoordinator.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 10.05.2023.
//

import UIKit

protocol ISimulationCoordinatorProtocol: AnyObject {
    func switchConfigurationFlow()
}

final class SimulationCoordinator {
    
    // MARK: - Properties
    
    private var childCoordinators: [Coordinatable] = []
    
    private var rootViewController: RootViewController
    
    private weak var parentCoordinator: ParentCoordinator?
    
    private let groupSize: Int
    
    private let infectionFactor: Int
    
    private let timeInterval: TimeInterval
    
        
    // MARK: - Life cycle
    
    init(rootViewController: RootViewController, parentCoordinator: ParentCoordinator?, groupSize: Int, infectionFactor: Int, timeInterval: TimeInterval) {
        self.rootViewController = rootViewController
        self.parentCoordinator = parentCoordinator
        self.groupSize = groupSize
        self.infectionFactor = infectionFactor
        self.timeInterval = timeInterval
    }
    
}



    // MARK: - ISimulationCoordinatorProtocol

extension SimulationCoordinator: Coordinatable {
    
    func start() {
        let virus = Virus(infectionFactor: self.infectionFactor)
        let viewModel = SimulationViewModel(
            coordinator: self,
            groupSize: self.groupSize,
            timeInterval: self.timeInterval,
            virus: virus
        )
        let simulationViewController = SimulationViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: simulationViewController)
        self.rootViewController.makeSwitch(to: navigationController)
    }
}



    // MARK: - ISimulationCoordinatorProtocol

extension SimulationCoordinator: ISimulationCoordinatorProtocol {
    
    func switchConfigurationFlow() {
        self.parentCoordinator?.switchConfigurationFlow()
    }

}

