//
//  ZoomCollectionView.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 07.05.2023.
//

import UIKit

final class ZoomCollectionView: UIView {
    
    // MARK: - Publiuc properties
    
    let collectionView: UICollectionView
    let scrollView: UIScrollView
    let dummyZoomView: UIView
    let layout: UICollectionViewFlowLayout
    
    
    // MARK: - Lifecycles
    
    init(frame: CGRect, layout: UICollectionViewFlowLayout) {
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.scrollView = UIScrollView(frame: frame)
        self.dummyZoomView = UIView(frame: frame)
        self.layout = layout
        
        super.init(frame: frame)
        
        self.setupView()
        self.setupConstraint()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let layout = self.layout as? ScalingLayoutProtocol {
            let size = layout.contentSizeForScale(self.scrollView.zoomScale)
            self.scrollView.contentSize = size
            self.dummyZoomView.frame = CGRect(origin: .zero, size: size)
        }
    }
    
    
    // MARK: - Private methods
    
    private func setupView() {
        self.addSubview(self.collectionView)
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.dummyZoomView)
        self.scrollView.bouncesZoom = false
        self.bringSubviewToFront(self.scrollView)
        
        self.collectionView.gestureRecognizers?.forEach { self.collectionView.removeGestureRecognizer($0) }
        self.scrollView.delegate = self
    }
    
    private func setupConstraint() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            self.scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
}



    // MARK: - UIScrollViewDelegate

extension ZoomCollectionView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return dummyZoomView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.contentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if let layout = self.layout as? ScalingLayoutProtocol, layout.getScale() != scrollView.zoomScale {
            layout.setScale(scrollView.zoomScale)
            self.layout.invalidateLayout()
            collectionView.contentOffset = scrollView.contentOffset
        }
    }
}









//extension ZoomCollectionView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        // cells might have been hidden by hideLingeringCells() so we must un-hide them.
//        cell.isHidden = false
//    }
//}
