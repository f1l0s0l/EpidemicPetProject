//
//  ConfigurationViewModel.swift.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 10.05.2023.
//

import Foundation

protocol IConfigurationViewModelProtocol: AnyObject {
    func didTabStartButton(groupSizeValue: String?, infectionFactorValue: String?, timeIntervalValue: String?)
}

final class ConfigurationViewModel {

    // MARK: - Private properties
    
    private let coordinator: IConfigurationCoordinatorProtocol
    
    
    // MARK: - Init
    
    init(coordinator: IConfigurationCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
}



    // MARK: - IFirstViewModel

extension ConfigurationViewModel: IConfigurationViewModelProtocol {
    
    func didTabStartButton(groupSizeValue: String?, infectionFactorValue: String?, timeIntervalValue: String?) {
        guard let groupSizeString = groupSizeValue,
              let groupSizeInt = Int(groupSizeString)
        else {
            // алерт с ошибкой в кол- ве людей
            return
        }
        
        guard let infectionFactorString = infectionFactorValue,
              let infectionFactorInt = Int(infectionFactorString)
        else {
            // алерт с ошибкой в кол- ве зараженых
            return
        }
        
        guard let timeIntervalString = timeIntervalValue,
              let timeIntervalTimeIntervar = TimeInterval(timeIntervalString)
        else {
            // алерт с ошибкой в таймере
            return
        }
        
        self.coordinator.switchSimulationFlow(
            groupSize: groupSizeInt,
            infectionFactor: infectionFactorInt,
            timeInterval: timeIntervalTimeIntervar
        )
    }
    
}
