//
//  SimulationViewModel.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 09.05.2023.
//

import Foundation

protocol ISimulationViewModelProtocol: AnyObject {
    
    var healthyHumans: [HumanViewModel] { get }
    var columns: Int { get }
    var stateChanged: ((SimulationViewModel.State) -> Void)? { get set }
    func didTapOnCell(index: Int)
    func didTapStopSimulationBarButtonItem()
}

final class SimulationViewModel {

    // MARK: - Enum
    
    enum State {
        case didChangeProgress(progress: Float, healthyCountLabel: Int, infectedCountLabel: Int)
    }
    
    
    // MARK: - Public properties
    
    lazy var healthyHumans: [HumanViewModel] = {
        return Array(0...self.groupSize - 1).map { HumanViewModel(id: $0) }
    }()
    
    var stateChanged: ((State) -> Void)?
    
    var columns: Int = 15
    
    
    // MARK: - Private properties

    private var state: State = .didChangeProgress(progress: 0, healthyCountLabel: 0, infectedCountLabel: 0) {
        didSet {
            self.stateChanged?(state)
        }
    }
    
    private let groupSize: Int
    
    private let timeInterval: TimeInterval
    
    private let virus: IVirusProtocol
    
    private var infectedHumans: Set<HumanViewModel> = []
    
    private let coordinator: ISimulationCoordinatorProtocol
    
    private let concurrentQueue = DispatchQueue(label: "TimerQueue", qos: .utility, attributes: .concurrent)

    private lazy var timer: Timer = {
        let timer = Timer(
            timeInterval: self.timeInterval,
            target: self,
            selector: #selector(self.didTimerDoInfect),
            userInfo: nil,
            repeats: true
        )
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }()
    
    
    // MARK: - Init
    
    init(coordinator: ISimulationCoordinatorProtocol, groupSize: Int, timeInterval: TimeInterval, virus: IVirusProtocol) {
        self.coordinator = coordinator
        self.groupSize = groupSize
        self.timeInterval = timeInterval
        self.virus = virus
        self.timer.fire()
    }
    
    
    // MARK: - Private methods
    
    private func doInfect() {
        self.concurrentQueue.async {
            
            var removeInInfectedHumans: Set<HumanViewModel> = []
            var insertInInfectedHumans: Set<HumanViewModel> = []
            
            for infectedHuman in self.infectedHumans {
                let neighbours = self.getNeighbors(infectedHuman: infectedHuman)
                
                switch self.virus.infectHumans(humans: neighbours) {
                    
                case .success(let newInfectedHumans):
                    insertInInfectedHumans = insertInInfectedHumans.union(newInfectedHumans)
                    
                case .failure(_):
                    removeInInfectedHumans.insert(infectedHuman)
                }
            }
            self.infectedHumans = self.infectedHumans.union(insertInInfectedHumans)
            self.infectedHumans = self.infectedHumans.symmetricDifference(removeInInfectedHumans)
            DispatchQueue.main.async {
                self.updateProgress()
            }
        }
    }
    
    private func getNeighbors(infectedHuman: HumanViewModel) -> Set<HumanViewModel> {
        var neighbours: Set<HumanViewModel> = []
        
        if let humanTop = self.healthyHumans.first(where: {$0.id == infectedHuman.id - self.columns }) {
            humanTop.directionOfInfection = .top
            neighbours.insert(humanTop)
        }
        if let humanBotton = self.healthyHumans.first(where: {$0.id == infectedHuman.id + self.columns }) {
            humanBotton.directionOfInfection = .bottom
            neighbours.insert(humanBotton)
        }
        
        if (infectedHuman.id + 1) % self.columns != 0,
           let humanRight = self.healthyHumans.first(where: { $0.id == infectedHuman.id + 1 })
        {
            humanRight.directionOfInfection = .right
            neighbours.insert(humanRight)
        }

        if (infectedHuman.id) % self.columns != 0,
           let humanLeft = self.healthyHumans.first(where: { $0.id == infectedHuman.id - 1 })
        {
            humanLeft.directionOfInfection = .left
            neighbours.insert(humanLeft)
        }
        
        return neighbours
    }
    
    private func updateProgress() {
        var progress: Float = 100
        
        let healthyCountLabel = self.healthyHumans.count
        let infectedCountLabel = self.healthyHumans.filter({ !$0.isHealthy }).count
        
        if infectedCountLabel != 0 {
            progress = 1.0 - Float(infectedCountLabel) / Float(healthyCountLabel)
        }
        
        let currentHealthyCountLabel = healthyCountLabel - infectedCountLabel
        
        self.state = .didChangeProgress(progress: progress, healthyCountLabel: currentHealthyCountLabel, infectedCountLabel: infectedCountLabel)
    }
    
    @objc
    private func didTimerDoInfect() {
        self.doInfect()
    }
}



    // MARK: - ISimulationViewModelProtocol

extension SimulationViewModel: ISimulationViewModelProtocol {
    
    func didTapOnCell(index: Int) {
        let currentHuman = self.healthyHumans[index]
        
        self.infectedHumans.insert(currentHuman)
        currentHuman.didInfected()
    }
    
    func didTapStopSimulationBarButtonItem() {
        self.coordinator.switchConfigurationFlow()
    }
    
}
