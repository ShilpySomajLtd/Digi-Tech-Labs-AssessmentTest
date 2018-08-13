//
//  Constants.swift
//  Digi-Tech-AssessmentTest
//
//  Created by ISMAIL HOSSAIN on 8/12/18.
//  Copyright © 2018 ISMAIL HOSSAIN. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Constants {
    static let API_URL = "http://77.68.80.27:4010/marketplaceapi/getsubmenulistbycategoryid/"
    static var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
}
