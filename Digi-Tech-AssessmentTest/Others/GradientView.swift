//
//  GradientView.swift
//  Sales Management
//
//  Created by Ismail Hossain on 9/6/18.
//  Copyright © 2018 Ismail Hossain. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var startColor: UIColor = UIColor.init(hex6: 0x54416b) {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var endColor: UIColor = UIColor.init(hex6: 0x2e2b63) {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var angle: Double = 0.00 {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView () {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [startColor.cgColor, endColor.cgColor]
        //        layer.startPoint.x = 0
        //        layer.startPoint.y = 0
        //        layer.endPoint.x = 1
        //        layer.endPoint.y = 1
    }
    //
    //    override func draw(_ rect: CGRect) {
    //        let gradient: CAGradientLayer = CAGradientLayer()
    //        gradient.frame = CGRect(x: CGFloat(0),
    //                                y: CGFloat(0),
    //                                width: superview!.frame.size.width,
    //                                height: superview!.frame.size.height)
    //        gradient.startPoint.x = 0
    //        gradient.startPoint.y = 0
    //        gradient.endPoint.x = 1
    //        gradient.endPoint.y = 1
    //        gradient.colors = [startColor.cgColor, endColor.cgColor]
    //        gradient.zPosition = -1
    //        layer.addSublayer(gradient)
    //    }
}
