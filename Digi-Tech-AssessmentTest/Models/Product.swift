//
//  Products.swift
//  Digi-Tech-AssessmentTest
//
//  Created by ISMAIL HOSSAIN on 8/11/18.
//  Copyright © 2018 ISMAIL HOSSAIN. All rights reserved.
//

import Foundation

struct Product: Codable {
    let RowNumber: String
    let ProductID: String
    let MDProductCategoryID: String
    let ProductName: String
    let SDetails: String
    let Details: String
    let SPath: String
    let MPath: String
    let Path: String
    let Price: Double
    let AlergimonicID​: String?
    let UnitName: String
    let PreferenceID: Int?
    let isModifier: Bool    
}
