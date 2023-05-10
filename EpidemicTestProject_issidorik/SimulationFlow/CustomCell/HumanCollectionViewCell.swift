//
//  HumanCollectionViewCell.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 05.05.2023.
//

import UIKit

final class HumanCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private properties
    
    private var viewModel: IHumanViewModelProtocol?
        
    lazy var humanView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var animateHumanView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.isHidden = true
        return view
    }()

    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.humanView.layer.cornerRadius = self.frame.height / 2
        self.animateHumanView.layer.cornerRadius = self.frame.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel?.stateChanged = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public methods
    
    func setViewModel(viewModel: HumanViewModel) {
        self.viewModel = viewModel
        self.humanView.backgroundColor = viewModel.isHealthy ? .systemGreen : .systemRed
        self.bindViewModel()
    }
    
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        self.viewModel?.stateChanged = { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .didInfected(let direction):
                self.animateHunamView(direction: direction)
            }
        }
        
    }
    
    private func setupView() {
        self.addSubview(self.humanView)
        self.addSubview(self.animateHumanView)
    }
    
    private func animateHunamView(direction: HumanViewModel.DirectionOfInfection) {
        var startPoint = self.humanView.center
        let width = self.humanView.frame.width
        
        switch direction {
        case .top:
            startPoint.y += width
            
        case .left:
            startPoint.x += width
            
        case .right:
            startPoint.x -= width
            
        case .bottom:
            startPoint.y -= width
            
        case .none:
            self.animateForUserInfected()
            return
        }
        
        self.animateHumanView.isHidden = false
        self.animateHumanView.center = CGPoint(x: startPoint.x, y: startPoint.y)
        self.animateForEpidemicInfected()
    }
    
    private func animateForEpidemicInfected() {
        UIView.animateKeyframes(
            withDuration: 0.5,
            delay: 0,
            options: []) {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.4) {
                        self.animateHumanView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                        self.animateHumanView.center = self.humanView.center
                    }
                UIView.addKeyframe(
                    withRelativeStartTime: 0.4,
                    relativeDuration: 0.6) {
                        self.humanView.backgroundColor = .red
                        self.humanView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }
            } completion: { _ in
            }
    }
    
    private func animateForUserInfected() {
        UIView.animateKeyframes(
            withDuration: 0.4,
            delay: 0,
            options: []) {
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 1) {
                        self.humanView.backgroundColor = .red
                    }
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 0.4) {
                        self.humanView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    }
                UIView.addKeyframe(
                    withRelativeStartTime: 0.4,
                    relativeDuration: 0.6) {
                        self.humanView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }
            } completion: { _ in
            }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.humanView.topAnchor.constraint(equalTo: self.topAnchor),
            self.humanView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.humanView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.humanView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.animateHumanView.topAnchor.constraint(equalTo: self.topAnchor),
            self.animateHumanView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.animateHumanView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.animateHumanView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
}
