//
//  ViewController.swift
//  Digi-Tech-AssessmentTest
//
//  Created by ISMAIL HOSSAIN on 8/11/18.
//  Copyright © 2018 ISMAIL HOSSAIN. All rights reserved.
//

import UIKit
import Alamofire
import ARSLineProgress

private let reuseIdentifier = "ProductCVCell"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var productSearchBar: UISearchBar!
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search: \(searchText)")
        if searchText == "" {
            searchView = false
        }
        filteredProducts.removeAll()
        if let products = productData?.data {
            for product in products {
                if product.ProductName.contains(searchText) {
                    filteredProducts.append(product)
                    searchView = true
                }
            }
        }
        collectionView.reloadData()
    }

    @IBOutlet weak var collectionView: UICollectionView!

    var columnSpace:CGFloat = 10
    var rowSpace:CGFloat = 10

    var productData: ProductData?
    var filteredProducts = [Product]()
    var searchView = false

    //defining the API URL
    let API_URL = "http://77.68.80.27:4010/marketplaceapi/getsubmenulistbycategoryid/"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        productSearchBar.delegate = self
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
    }
    
    @objc func rotated() {
        spacingInit()
        collectionView?.reloadData()
    }
    
    
    func spacingInit() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = columnSpace
        layout.minimumLineSpacing = rowSpace
        collectionView?.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let params = ["categoryid": 351, "pageindex": 1, "pagesize": 1000, "resturentid": 1]
        readFromServer(baseUrl: API_URL, params: params)
    }
    
    func readFromServer(baseUrl: String, params: [String: Any]) {
        ARSLineProgress.show()
        Alamofire.request(API_URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                let json = response.data
                do{
                    //created the json decoder
                    let decoder = JSONDecoder()
                    
                    //using the array to put values
                    self.productData = try decoder.decode(ProductData.self, from: json!)
                    if (self.productData?.is_success)! {
                        self.collectionView.reloadData()
                    }
                    ARSLineProgress.hide()
                } catch let err {
                    print(err)
                    ARSLineProgress.showFail()
                }
        }    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if searchView {
            return filteredProducts.count
        } else if let count = productData?.data.count {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProductCVCell {
            if searchView {
                cell.updateUI(product: (filteredProducts[indexPath.row]))
            } else {
                cell.updateUI(product: (productData?.data[indexPath.row])!)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var column:CGFloat = 1
        var row:CGFloat = 3

        switch UIDevice.current.orientation {
        case .landscapeRight, .landscapeLeft:
            column = 2
            row = 2
        case .portrait, .portraitUpsideDown:
            column = 1
            row = 3
        default:
            column = 1
            row = 3
        }
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            column = 2
        case .phone: break
        case .unspecified: break
        case .tv: break
        case .carPlay: break
        }

        
        let width = (collectionView.frame.width - (columnSpace * (column - 1))) / column
        var height = (collectionView.frame.height - (rowSpace * (row - 1))) / row
        
        let details = productData?.data[indexPath.row].Details

        
        height = CGFloat(120 + Double(details?.count ?? 0) / 1.5)

        if searchView {
            let details = filteredProducts[indexPath.row].Details
            height = CGFloat(120 + Double(details.count) / 1.5)
        }
        
        
        let minWidth: CGFloat = 50
        let minHeight: CGFloat = 50
        return CGSize(width: width > minWidth ? width: minWidth, height: height > minHeight ? height: minHeight)
    }
    
}

