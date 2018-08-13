//
//  ProductCVCell.swift
//  Digi-Tech-AssessmentTest
//
//  Created by ISMAIL HOSSAIN on 8/11/18.
//  Copyright © 2018 ISMAIL HOSSAIN. All rights reserved.
//

import UIKit

protocol MyCellDelegate: class {
    func clicked(_ currentItem: Product)
    func other()
}

class ProductCVCell: UICollectionViewCell, UIPopoverPresentationControllerDelegate {
    
    weak var delegate : MyCellDelegate?
    var currentItem: Product?
    
    @IBAction func removeButtonClick(_ sender: UIButton) {
        if let item = currentItem {
            delegate?.clicked(item)
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBOutlet weak var productIV: UIImageView!
    @IBOutlet weak var productIDL: UILabel!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var quantityL: UILabel!
    @IBOutlet weak var descriptionL: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    func updateUI(product: Product, isEditable: Bool) {
        currentItem = product

        removeButton.isHidden = !isEditable

        productIDL.text = "ID: \(product.productID ?? "")"
        nameL.text = product.productName ?? ""
        priceL.text = "Price: $\(product.price)"
        quantityL.text = "Qty: \(product.quanity)"
        descriptionL.text = product.details ?? ""
        
        if let urlPath = product.mPath, let url = URL(string: urlPath) {
            productIV.contentMode = .scaleAspectFit
            downloadImage(url: url)
        } else {
            productIV.image = #imageLiteral(resourceName: "product-default")
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.productIV.image = UIImage(data: data)
            }
        }
    }
}
