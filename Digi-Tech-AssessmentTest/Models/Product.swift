//
//  Products.swift
//  Digi-Tech-AssessmentTest
//
//  Created by ISMAIL HOSSAIN on 8/11/18.
//  Copyright © 2018 ISMAIL HOSSAIN. All rights reserved.
//

import UIKit
import CoreData

class Product: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case ProductID
        case ProductName
        case RowNumber
        case MDProductCategoryID
        case SDetails
        case Details
        case SPath
        case MPath
        case Path
        case Price
        case AlergimonicID
        case UnitName
        case PreferenceID
        case isModifier
        case Quantity
    }
    
    // MARK: - Core Data Managed Object
    
    @NSManaged public var alergimonicID: String?
    @NSManaged public var details: String?
    @NSManaged public var isModifier: Bool
    @NSManaged public var mdProductCategoryID: String?
    @NSManaged public var mPath: String?
    @NSManaged public var path: String?
    @NSManaged public var preferenceID: Int16
    @NSManaged public var price: Double
    @NSManaged public var productID: String?
    @NSManaged public var productName: String?
    @NSManaged public var quanity: Double
    @NSManaged public var rowNumber: String?
    @NSManaged public var sDetails: String?
    @NSManaged public var sPath: String?
    @NSManaged public var unitName: String?

    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        
        let context = Constants.container?.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Product", in: context!) else {
            fatalError("Failed to decode Product")
        }

        self.init(entity: entity, insertInto: context!)
                
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.alergimonicID = try container.decodeIfPresent(String.self, forKey: .AlergimonicID)
        self.details = try container.decodeIfPresent(String.self, forKey: .Details)
        self.isModifier = (try container.decodeIfPresent(Bool.self, forKey: .isModifier)) ?? false
        self.mdProductCategoryID = try container.decodeIfPresent(String.self, forKey: .MDProductCategoryID)
        self.mPath = try container.decodeIfPresent(String.self, forKey: .MPath)
        self.path = try container.decodeIfPresent(String.self, forKey: .Path)
        self.preferenceID = (try container.decodeIfPresent(Int16.self, forKey: .PreferenceID)) ?? 0
        self.price = (try container.decodeIfPresent(Double.self, forKey: .Price)) ?? 0
        self.productID = try container.decodeIfPresent(String.self, forKey: .ProductID)
        self.productName = try container.decodeIfPresent(String.self, forKey: .ProductName)
        self.quanity = (try container.decodeIfPresent(Double.self, forKey: .Quantity)) ?? 0
        self.rowNumber = try container.decodeIfPresent(String.self, forKey: .RowNumber)
        self.sDetails = try container.decodeIfPresent(String.self, forKey: .SDetails)
        self.sPath = try container.decodeIfPresent(String.self, forKey: .SPath)
        self.unitName = try container.decodeIfPresent(String.self, forKey: .UnitName)
        
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alergimonicID, forKey: .AlergimonicID)
        try container.encode(details, forKey: .Details)
        try container.encode(isModifier, forKey: .isModifier)
        try container.encode(mdProductCategoryID, forKey: .MDProductCategoryID)
        try container.encode(mPath, forKey: .MPath)
        try container.encode(path, forKey: .Path)
        try container.encode(preferenceID, forKey: .PreferenceID)
        try container.encode(price, forKey: .Price)
        try container.encode(productID, forKey: .ProductID)
        try container.encode(productName, forKey: .ProductName)
        try container.encode(quanity, forKey: .Quantity)
        try container.encode(rowNumber, forKey: .RowNumber)
        try container.encode(sDetails, forKey: .SDetails)
        try container.encode(sPath, forKey: .SPath)
        try container.encode(unitName, forKey: .UnitName)
    }
}

