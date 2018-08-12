//
//  ProductCVCell.swift
//  Digi-Tech-AssessmentTest
//
//  Created by ISMAIL HOSSAIN on 8/11/18.
//  Copyright © 2018 ISMAIL HOSSAIN. All rights reserved.
//

import UIKit

class ProductCVCell: UICollectionViewCell {
    @IBOutlet weak var productIV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var quantityL: UILabel!
    @IBOutlet weak var descriptionL: UILabel!
    
    func updateUI(product: Product) {
        nameL.text = product.ProductName
        priceL.text = "Price: $\(product.Price)"
        quantityL.text = "ID: \(product.ProductID)"
        descriptionL.text = product.Details
        
        if let url = URL(string: product.MPath) {
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
