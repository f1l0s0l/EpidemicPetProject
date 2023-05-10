//
//  Virus.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 07.05.2023.
//

import Foundation

enum VirusError: Error {
    case humanInIsolation
}

protocol IVirusProtocol: AnyObject {
    func infectHumans(humans: Set<HumanViewModel>) -> Result<Set<HumanViewModel>, VirusError>
}

final class Virus {

    // MARK: - Private properties
    
    let infectionFactor: Int
    
    
    // MARK: - Init
    
    init(infectionFactor: Int) {
        self.infectionFactor = infectionFactor
    }
}



    // MARK: - IVirusProtocol

extension Virus: IVirusProtocol {
    
    func infectHumans(humans: Set<HumanViewModel>) -> Result<Set<HumanViewModel>, VirusError> {
        guard !humans.filter({ $0.isHealthy }).isEmpty else {
            return .failure(.humanInIsolation)
        }
        
        let countFocusHuman = Int.random(in: 0...humans.count)
        guard countFocusHuman != 0,
              self.infectionFactor != 0
        else {
            return .success([])
        }
        
        let countInfectHuman = countFocusHuman > self.infectionFactor ? self.infectionFactor : countFocusHuman
        var resultArray: Set<HumanViewModel> = []
        
        let randomHumans = humans.shuffled().prefix(countInfectHuman)
        
        randomHumans.forEach { infectHuman in
            if infectHuman.isHealthy {
                resultArray.insert(infectHuman)
                
                DispatchQueue.main.sync {
                    infectHuman.didInfected()
                }
            }
        }
        
        return .success(resultArray)
    }
    
}
