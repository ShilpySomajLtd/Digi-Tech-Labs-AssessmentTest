//
//  ProductData.swift
//  Digi-Tech-AssessmentTest
//
//  Created by ISMAIL HOSSAIN on 8/11/18.
//  Copyright © 2018 ISMAIL HOSSAIN. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct ProductData: Codable {
    var data: [Product]?
    let is_success: Bool
    let message: String?
    let version: String?
}
