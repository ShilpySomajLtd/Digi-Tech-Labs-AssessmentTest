//
//  RoundedView.swift
//  Sales Management
//
//  Created by Ismail Hossain on 11/6/18.
//  Copyright © 2018 Ismail Hossain. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            updateView()
        }
    }
    
    func updateView () {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}
