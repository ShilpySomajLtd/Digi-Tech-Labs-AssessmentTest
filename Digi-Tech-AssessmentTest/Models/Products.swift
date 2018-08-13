//
//  Products.swift
//  Digi-Tech-AssessmentTest
//
//  Created by ISMAIL HOSSAIN on 8/13/18.
//  Copyright © 2018 ISMAIL HOSSAIN. All rights reserved.
//

import UIKit
import CoreData

class Products: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case is_success
        case message
    }
    
    // MARK: - Core Data Managed Object
    @NSManaged public var is_success: Bool
    @NSManaged public var message: String?
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Products", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
                
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.is_success = (try container.decodeIfPresent(Bool.self, forKey: .is_success))!
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(is_success, forKey: .is_success)
        try container.encode(message, forKey: .message)
    }
}

public extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

