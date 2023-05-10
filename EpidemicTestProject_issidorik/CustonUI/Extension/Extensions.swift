//
//  Extensions.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 07.05.2023.
//

import UIKit

extension CGSize {
    func scale(_ factor: CGFloat) -> CGSize {
        let transform = CGAffineTransform(scaleX: factor, y: factor)
        return self.applying(transform)
    }
}

extension CGRect {
    func scale(_ factor: CGFloat) -> CGRect {
        let transform = CGAffineTransform(scaleX: factor, y: factor)
        return self.applying(transform)
    }
}

extension UICollectionView {
    
    func getLingeringCells() -> [UICollectionViewCell] {
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let visibleCells: [UIView] = self.visibleCells
        
        return subviews.filter { view in
            view is UICollectionViewCell &&
            visibleRect.intersects(view.frame) &&
            !visibleCells.contains(view)
        } as! [UICollectionViewCell]
    }
}
