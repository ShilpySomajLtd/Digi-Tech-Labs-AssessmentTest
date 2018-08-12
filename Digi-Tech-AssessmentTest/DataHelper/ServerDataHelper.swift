//
//  ServerDataHelper.swift
//  Digi-Tech-AssessmentTest
//
//  Created by ISMAIL HOSSAIN on 8/12/18.
//  Copyright © 2018 ISMAIL HOSSAIN. All rights reserved.
//

import Foundation
import Alamofire
import ARSLineProgress

struct ServerDataHelper {
    
    func readFromServer(baseUrl: String, params: [String: Any], handler: @escaping ((ProductData)->Void)) {
        ARSLineProgress.show()
        Alamofire.request(baseUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                let json = response.data
                do {
                    // Created the json decoder
                    let decoder = JSONDecoder()

                    // Using the array to put values
                    let productData = try decoder.decode(ProductData.self, from: json!)
                    handler(productData)
                    
                } catch let err {
                    print(err)
                    ARSLineProgress.showFail()
                }
        }
    }
}
