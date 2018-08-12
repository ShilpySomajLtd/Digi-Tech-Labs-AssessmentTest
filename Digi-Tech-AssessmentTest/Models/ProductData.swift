//
//  ProductData.swift
//  Digi-Tech-AssessmentTest
//
//  Created by ISMAIL HOSSAIN on 8/11/18.
//  Copyright © 2018 ISMAIL HOSSAIN. All rights reserved.
//

import Foundation

struct ProductData: Codable {
    let data: [Product]
    let is_success: Bool
    let message: String
    let version: String
}
