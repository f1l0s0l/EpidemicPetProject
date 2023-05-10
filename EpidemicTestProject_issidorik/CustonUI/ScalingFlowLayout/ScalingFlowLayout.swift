//
//  ScalingFlowLayout.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 07.05.2023.
//

import Foundation
import UIKit

final class ScalingFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Public properties
    let columns: CGFloat
    
    
    // MARK: - Private Properties
    
    private var scale: CGFloat
    private var attributes: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = .zero
    

    // MARK: - Init
    
    init(itemSize: CGSize, columns: CGFloat, itemSpacing: (line: CGFloat, interitem: CGFloat), scale: CGFloat) {
        self.columns = columns
        self.scale = scale
        super.init()
        
        self.itemSize = itemSize
        
        self.minimumLineSpacing = itemSpacing.line
        self.minimumInteritemSpacing = itemSpacing.interitem
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    
    // MARK: - Methods

    override  func prepare() {
        super.prepare()
        self.contentSize = contentSizeForScale(self.scale)
        let itemCount = self.collectionView!.numberOfItems(inSection: 0)
        let columnCount = self.columns
        
        attributes = (0..<itemCount).map { idx in
            let rowIdx = floor(Double(idx) / Double(columnCount))
            let columnIdx =  idx % Int(columnCount)
            let pt = CGPoint(
                x: (self.itemSize.width + self.minimumInteritemSpacing) * CGFloat(columnIdx),
                y: (self.itemSize.height + self.minimumLineSpacing) * CGFloat(rowIdx)
            )
            let rect = CGRect(origin: pt, size: self.itemSize)
            let attr = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: idx, section: 0))
            attr.frame = rect.scale(self.scale)
            return attr
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes.first { $0.indexPath == indexPath }
    }
    
}



    // MARK: - ScalingLayoutProtocol

extension ScalingFlowLayout: ScalingLayoutProtocol {
    
    func contentSizeForScale(_ scale: CGFloat) -> CGSize {
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        let rowCount = ceil(CGFloat(itemCount)/CGFloat(columns))
        let sz = CGSize(
            width: itemSize.width * columns + self.minimumInteritemSpacing * (columns - 1), // CHEK!!! MB REVERS!!!
            height: itemSize.height * rowCount + self.minimumLineSpacing * (rowCount - 1)
        )
        return sz.scale(scale)
    }
    
    func getScale() -> CGFloat {
        return self.scale
    }
    
    func setScale(_ scale: CGFloat) {
        self.scale = scale
    }
    
}
