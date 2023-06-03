//
//  ButtonExtension.swift
//  MemeApp
//
//  Created by UbiiPagos on 2/6/23.
//

import Foundation
import UIKit

extension UIButton {
    //MARK: Ubii Card Gradient
    func ubiiCardButtonGradient(colours: [UIColor], cornerMultiplier: CGFloat) {
        self.backgroundColor = .clear
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.cornerRadius = self.bounds.height * cornerMultiplier
        gradient.name = "gradient"
        for item in self.layer.sublayers ?? [] where item.name == "gradient" {
            item.removeFromSuperlayer()
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
}
