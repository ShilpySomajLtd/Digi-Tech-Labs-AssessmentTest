//
//  ViewController.swift
//  Digi-Tech-AssessmentTest
//
//  Created by ISMAIL HOSSAIN on 8/11/18.
//  Copyright © 2018 ISMAIL HOSSAIN. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import ARSLineProgress

private let reuseIdentifier = "ProductCVCell"

class ProductsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var productSearchBar: UISearchBar!
    
    var blockOperations = [BlockOperation]()
    var shouldReloadCollectionView = false
    
    deinit {
        for operation: BlockOperation in blockOperations {
            operation.cancel()
        }
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    var productFRC: NSFetchedResultsController<Product>?

    func fetchedControllerInit() {
        
        let context = Constants.container?.viewContext
        let request: NSFetchRequest<Product> = Product.fetchRequest() as! NSFetchRequest<Product>
        request.sortDescriptors = [NSSortDescriptor(key: "productName", ascending: true)]
        
        productFRC = NSFetchedResultsController<Product> (
            fetchRequest: request,
            managedObjectContext: context!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        productFRC?.delegate = self
        try? productFRC?.performFetch()
        collectionView?.reloadData()
    }
    
    
    var isEditable = false
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var removeItemBarButton: UIBarButtonItem!
    
    @IBAction func doneEditing(_ sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItems = [removeItemBarButton, addBarButton]
        isEditable = false
        collectionView.reloadData()
    }
    @IBAction func addProduct(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "createProductPopoverSegue", sender: nil)
    }
    
    @IBAction func removeItem(_ sender: UIBarButtonItem) {
        doneBarButton.isEnabled = true
        doneBarButton.title = "Done"
        self.navigationItem.rightBarButtonItems = [doneBarButton, addBarButton]
        isEditable = true
        collectionView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        var predicate: NSPredicate? = nil
        if searchText.count != 0 {
            predicate = NSPredicate(format: "(productName contains [cd] %@)", searchText)
        }
        productFRC?.fetchRequest.predicate = predicate
        try? productFRC?.performFetch()
        collectionView?.reloadData()

    }

    @IBOutlet weak var collectionView: UICollectionView!

    var columnSpace:CGFloat = 10
    var rowSpace:CGFloat = 10

    var productData: ProductData?
    var filteredProducts = [Product]()
    
    //defining the API URL

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProductsVC.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        productSearchBar.delegate = self
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
        readFromServer()
        
    }
    
    func readFromServer() {
        // Clear Existing CoreData
        ProductController(persistentContainer: Constants.container!).clearStorage()
        
        // Fetch New Data From Server
        let params = ["categoryid": 351, "pageindex": 1, "pagesize": 1000, "resturentid": 1]
        let serverDataHelper = ServerDataHelper()
        serverDataHelper.readFromServer(baseUrl: Constants.API_URL, params: params) { (productData) in
            if productData.is_success {
                self.productData = productData
                if let products = productData.data {
                    self.filteredProducts = products
                }
                print("Total Product: \(ProductController(persistentContainer: Constants.container!).fetchFromStorage()?.count ?? 0)")
                self.fetchedControllerInit()
            }
            ARSLineProgress.hide()
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

        popoverPresentationController?.delegate = self

        navBarInit()
        
    }
    
    func navBarInit() {
        
        self.navigationItem.rightBarButtonItems = [removeItemBarButton, doneBarButton, addBarButton]

        doneBarButton.isEnabled = false
        doneBarButton.title = ""
        isEditable = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createProductPopoverSegue" {
            let popoverViewController = segue.destination as! UINavigationController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
    
    @IBAction func unwindToProductsVC(segue:UIStoryboardSegue) {
        if let source = segue.source as? CreateProductVC {
            if let product = source.product {
                filteredProducts.append(product)
                productData?.data?.append(product)
                collectionView.reloadData()
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productFRC?.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProductCVCell {
            cell.updateUI(product: (productFRC?.object(at: indexPath))!, isEditable: isEditable)

            cell.delegate = self
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var column:CGFloat = 2
        let row: CGFloat = 2
        switch UIDevice.current.userInterfaceIdiom {
        case .pad: break
        case .phone:
            switch UIDevice.current.orientation {
            case .faceUp, .faceDown, .portrait, .portraitUpsideDown:
                column = 1
            default:
                column = 2
            }
        case .unspecified: break
        case .tv: break
        case .carPlay: break
        }
        let collectionViewWidth = (collectionView.frame.width - (columnSpace * (column - 1))) / column
        let collectionViewHeight = (collectionView.frame.height - (rowSpace * (row - 1))) / row
        
        
        let font = UIFont(name: "Helvetica", size: 17.0)
        
        var height = CGFloat(120)
        let width = collectionViewWidth

        if let details =  productFRC?.object(at: indexPath).details {
            height = heightForView(text: details, font: font!, width: collectionViewWidth) + CGFloat(120)
//            height = CGFloat(120 + Double(details.count) / 1.3)
        }

        let minWidth: CGFloat = 50
        let minHeight: CGFloat = 50
        return CGSize(width: width > minWidth ? width: minWidth, height: height > minHeight ? height: minHeight)
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 5
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}

extension ProductsVC: MyCellDelegate {
    func clicked(_ currentItem: Product) {
        
        let context = Constants.container?.viewContext
        context?.perform {
            if let indexPath = self.productFRC?.indexPath(forObject: currentItem) {
                if let item = self.productFRC?.object(at: indexPath) {
                    context?.delete(item)
                    self.fetchedControllerInit()
                }
            }
        }
    }
    
    func other() {
    }
}


extension ProductsVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == NSFetchedResultsChangeType.insert {
            print("Insert Object: \(String(describing: newIndexPath))")
            
            if (collectionView?.numberOfSections)! > 0 {
                if collectionView?.numberOfItems( inSection: newIndexPath!.section ) == 0 {
                    self.shouldReloadCollectionView = true
                } else {
                    blockOperations.append(
                        BlockOperation(block: { [weak self] in
                            if let this = self {
                                this.collectionView?.insertItems(at: [newIndexPath!])
                            }
                        })
                    )
                }
            } else {
                self.shouldReloadCollectionView = true
            }
        }
        else if type == NSFetchedResultsChangeType.update {
            print("Update Object: \(String(describing: indexPath))")
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.reloadItems(at: [indexPath!])
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.move {
            print("Move Object: \(String(describing: indexPath))")
            
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.moveItem(at: indexPath!, to: newIndexPath!)
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.delete {
            print("Delete Object: \(String(describing: indexPath))")
            if collectionView?.numberOfItems( inSection: indexPath!.section ) == 1 {
                self.shouldReloadCollectionView = true
            } else {
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            this.collectionView!.deleteItems(at: [indexPath!])
                        }
                    })
                )
            }
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        if type == NSFetchedResultsChangeType.insert {
            print("Insert Section: \(sectionIndex)")
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.insertSections(NSIndexSet(index: sectionIndex) as IndexSet)
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.update {
            print("Update Section: \(sectionIndex)")
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet)
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.delete {
            print("Delete Section: \(sectionIndex)")
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet)
                    }
                })
            )
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        if shouldReloadCollectionView {
            collectionView?.reloadData()
        } else {
            collectionView?.performBatchUpdates({
                for operation in self.blockOperations {
                    operation.start()
                }
            }, completion: { [weak self] (completed) in
                //                let lastItem = (self?.productFRC?.sections![0].numberOfObjects)! - 1
                //                let indexPath = IndexPath(item: lastItem, section: 0)
                //                self?.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
            })
        }
    }
}


