//
//  SlacingLayoutProtocol.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 07.05.2023.
//

import Foundation
import CoreGraphics

protocol ScalingLayoutProtocol {
    func getScale() -> CGFloat
    func setScale(_ scale: CGFloat) -> Void
    func contentSizeForScale(_ scale: CGFloat) -> CGSize
}
