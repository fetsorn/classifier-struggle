//
//  UIImage+ImageWith.swift
//  classifier-struggle
//
//  Created by Anton Davydov on 02.10.2020.
//  Copyright © 2020 Fet Sorn. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics


// https://stackoverflow.com/a/40867644
extension UIImage {
    func imageWith(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }
        
        return image.withRenderingMode(self.renderingMode)
    }
}
