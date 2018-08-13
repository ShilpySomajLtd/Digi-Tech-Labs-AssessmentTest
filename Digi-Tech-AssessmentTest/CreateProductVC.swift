//
//  CreateProductVC.swift
//  Digi-Tech-AssessmentTest
//
//  Created by ISMAIL HOSSAIN on 8/12/18.
//  Copyright © 2018 ISMAIL HOSSAIN. All rights reserved.
//

import UIKit
import CoreData

class CreateProductVC: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var nameTF:UITextField!
    @IBOutlet weak var productIDTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var quantityTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextView!
    @IBOutlet weak var productIV: UIImageView!
    
    var product: Product?

    @IBAction func backToVC(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToProductsVC", sender: self)
    }
    
    func checkError() -> Bool {
        var errorMessage = ""
        if let name = nameTF.text, name.count <= 0 {
            errorMessage = "Product Name Not Set!"
        }
        if let productID = productIDTF.text, productID.count <= 0 {
            errorMessage += "\nProduct ID Not Set!"
        }
        if errorMessage.count > 0 {
            let alertController = UIAlertController(title: "Invalid Data", message: errorMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            { action -> Void in
            })
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @IBAction func createNewProduct(_ sender: UIBarButtonItem) {

        if checkError() {
            
            let context = Constants.container?.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "Product", in: context!) else {
                fatalError("Failed to decode Product")
            }
            
            do {
                let newProduct = Product(entity: entity, insertInto: context)
                newProduct.productName = nameTF.text
                newProduct.productID = productIDTF.text
                newProduct.details = descriptionTF.text
                newProduct.price = Double(priceTF.text ?? "0.0") ?? 0
                newProduct.quanity = Double(quantityTF.text ?? "0.0") ?? 0
                product = newProduct
                try context?.save()
                print("Total Product: \(ProductController(persistentContainer: Constants.container!).fetchFromStorage()?.count ?? 0)")
                performSegue(withIdentifier: "unwindToProductsVC", sender: self)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //popover size
        self.preferredContentSize = CGSize(width: 320, height: 200)
        //sets the arrow of the popover to same color of background
        self.popoverPresentationController?.backgroundColor = self.view.backgroundColor
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle
    {
        return .none
    }

}
