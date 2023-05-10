//
//  HumanViewModel.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 07.05.2023.
//

import Foundation

protocol IHumanViewModelProtocol: AnyObject {
    var id: Int { get }
    var isHealthy: Bool { get set }
    var stateChanged: ((HumanViewModel.State) -> Void)? { get set }
    var directionOfInfection: HumanViewModel.DirectionOfInfection { get set }
    func didInfected()
}

final class HumanViewModel {
    
    // MARK: - Enum
    
    enum DirectionOfInfection {
        case top
        case left
        case right
        case bottom
        case none
    }
    
    enum State {
        case didInfected(direction: DirectionOfInfection)
    }
    
    
    // MARK: - Public properties
    
    private(set) var id: Int
    
    var isHealthy: Bool = true
    
    var stateChanged: ((State) -> Void)?
    
    var directionOfInfection: HumanViewModel.DirectionOfInfection = .none
    
    
    // MARK: - Private properties
        
    private var state: State = .didInfected(direction: .none) {
        didSet {
            self.stateChanged?(state)
        }
    }
    
    
    // MARK: - Init
    
    init(id: Int) {
        self.id = id
    }
    
}



    // MARK: - IHumanViewModelProtocol

extension HumanViewModel: IHumanViewModelProtocol {
    
    func didInfected() {
        if self.isHealthy {
            self.isHealthy = false
            self.state = .didInfected(direction: self.directionOfInfection)
        } else {
            self.state = .didInfected(direction: .none)
        }
    }
}



    // MARK: - Hashable

extension HumanViewModel: Hashable {
    
    static func == (lhs: HumanViewModel, rhs: HumanViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
