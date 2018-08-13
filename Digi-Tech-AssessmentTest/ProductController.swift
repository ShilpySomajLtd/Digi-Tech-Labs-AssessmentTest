//
//  ProductController.swift
//  Digi-Tech-AssessmentTest
//
//  Created by ISMAIL HOSSAIN on 8/13/18.
//  Copyright © 2018 ISMAIL HOSSAIN. All rights reserved.
//

import Foundation
import CoreData

protocol ProductControllerProtocol {
}

class ProductController: ProductControllerProtocol {
    
    private let persistentContainer: NSPersistentContainer
    
    static let entityName = "Product"
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
}

extension ProductController {
    
    func fetchFromStorage() -> [Product]? {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Product>(entityName: ProductController.entityName)
//        let sortDescriptor1 = NSSortDescriptor(key: "role", ascending: true)
//        let sortDescriptor2 = NSSortDescriptor(key: "username", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        do {
            let product = try managedObjectContext.fetch(fetchRequest)
            return product
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func parse(_ jsonData: Data) -> Bool {
        do {
            guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                fatalError("Failed to retrieve context")
            }
            
            // Clear storage and save managed object instances
//            if currentPage == 0 {
//                clearStorage()
//            }
            
            // Parse JSON data
            let managedObjectContext = persistentContainer.viewContext
            let decoder = JSONDecoder()
            decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
            _ = try decoder.decode(Product.self, from: jsonData)
//            try managedObjectContext.save()
            
            print("Data in CoreData: \(String(describing: fetchFromStorage()?.count))")
            return true
        } catch let error {
            print(error)
            return false
        }
    }
    
    func clearStorage() {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ProductController.entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
}
