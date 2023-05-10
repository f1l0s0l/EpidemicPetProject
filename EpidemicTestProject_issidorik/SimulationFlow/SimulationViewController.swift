//
//  SimulationViewController.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 05.05.2023.
//

import UIKit

final class SimulationViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: ISimulationViewModelProtocol
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemGreen
        progressView.trackTintColor = .systemRed
        progressView.progress = 1
        progressView.accessibilityNavigationStyle = .combined
        return progressView
    }()
    
    private lazy var healthyCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infectedCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scalingFlowLayout: ScalingFlowLayout = {
        let columns = CGFloat(self.viewModel.columns) // !!!!!!!!!!!!!!!!!!!!!!!!
        
        let itemWidth = (self.view.frame.width - ((columns - 1) * 2.5)) / columns
        
        let scalingFlowLayout = ScalingFlowLayout(
            itemSize: CGSize(width: itemWidth, height: itemWidth),
            columns: CGFloat(self.viewModel.columns),
            itemSpacing: (2.5, 2.5), // !!!!!!
            scale: 1.0
        )
        return scalingFlowLayout
    }()
    
    private lazy var zoomCollectionView: ZoomCollectionView = {
        let zoomCollectionView = ZoomCollectionView(frame: .zero, layout: scalingFlowLayout)
        zoomCollectionView.translatesAutoresizingMaskIntoConstraints = false
        zoomCollectionView.collectionView.dataSource = self
        
        zoomCollectionView.scrollView.minimumZoomScale = 1.0
        zoomCollectionView.scrollView.zoomScale = 1.0
        zoomCollectionView.scrollView.maximumZoomScale = 4.0
        
        zoomCollectionView.collectionView.register(HumanCollectionViewCell.self, forCellWithReuseIdentifier: "HumanCollectionViewCellID")
        return zoomCollectionView
    }()
    
    
    // MARK: - Lifecycles

    init(viewModel: ISimulationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupConstraints()
        self.setupGestureRecognizer()
        self.setupNavigationBar()
        self.bindViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // вызвать остановку таймера
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let columns = CGFloat(self.viewModel.columns) // !!!!!!!!!!!!!!!!!!!!!!!!
        
        let itemWidth = (self.view.frame.width - ((columns - 1) * 2.5)) / columns // !!!!!
        self.scalingFlowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }

    
    // MARK: - Private methods
    
    private func bindViewModel () {
        self.viewModel.stateChanged = { [weak self] state in
            switch state {
            case .didChangeProgress(let progress, let healthyCount, let infectedCount):
                self?.healthyCountLabel.text = "Здоровых: \(healthyCount)"
                self?.infectedCountLabel.text = "Больных: \(infectedCount)"
                self?.progressView.setProgress(progress, animated: true)
            }
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.zoomCollectionView)
        self.view.addSubview(self.progressView)
        self.view.addSubview(self.healthyCountLabel)
        self.view.addSubview(self.infectedCountLabel)
    }
    
    private func setupNavigationBar() {
        let stopSimulationBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "clear"),
            style: .done,
            target: self,
            action: #selector(self.didTapStopSimulationBarButtonItem)
        )
        self.navigationItem.rightBarButtonItem = stopSimulationBarButtonItem
    }
    
    @objc
    private func didTapStopSimulationBarButtonItem() {
        self.viewModel.didTapStopSimulationBarButtonItem()
    }
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapGestureRecognizer(_:)))
        self.zoomCollectionView.scrollView.addGestureRecognizer(tapGestureRecognizer)
        
        let longTapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.didLongTapGestureRecognizer(_:)))
        self.zoomCollectionView.scrollView.addGestureRecognizer(longTapGestureRecognizer)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.progressView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.progressView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            self.progressView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            self.progressView.heightAnchor.constraint(equalToConstant: 15),
            
            self.healthyCountLabel.topAnchor.constraint(equalTo: self.progressView.bottomAnchor, constant: 5),
            self.healthyCountLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            
            self.infectedCountLabel.topAnchor.constraint(equalTo: self.progressView.bottomAnchor, constant: 10),
            self.infectedCountLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5),
            
            self.zoomCollectionView.topAnchor.constraint(equalTo: self.healthyCountLabel.bottomAnchor, constant: 5),
            self.zoomCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.zoomCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.zoomCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    
    @objc
    private func didTapGestureRecognizer(_ tapGesure: UITapGestureRecognizer) {
        let point = tapGesure.location(in: self.zoomCollectionView.collectionView)
        
        guard let indexPathForCell = self.zoomCollectionView.collectionView.indexPathForItem(at: point) else {
            return
        }
        
        self.viewModel.didTapOnCell(index: indexPathForCell.item)
    }
    
    @objc
    private func didLongTapGestureRecognizer(_ longTapGestureRecognizer: UILongPressGestureRecognizer) {
        guard longTapGestureRecognizer.state == .changed,
              let indexPathForItem = self.zoomCollectionView.collectionView.indexPathForItem(
                at: longTapGestureRecognizer.location(in: self.zoomCollectionView.collectionView)
              )
        else {
            return
        }
        self.viewModel.didTapOnCell(index: indexPathForItem.item)
    }
    
}




//MARK: - UICollectionViewDataSource

extension SimulationViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.healthyHumans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HumanCollectionViewCellID", for: indexPath) as? HumanCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setViewModel(viewModel: self.viewModel.healthyHumans[indexPath.item])
        return cell
    }
    
}



//MARK: - UICollectionViewDelegateFlowLayout

extension SimulationViewController: UICollectionViewDelegateFlowLayout {

    
}
