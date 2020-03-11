//
//  SharedPersistentContainer.swift
//  ABBYY
//
//  Created by Roman Dubinskiy on 3/9/20.
//  Copyright © 2020 Roman Dubinskiy. All rights reserved.
//

import Foundation
import CoreData

class SharedPersistentContainer: NSPersistentContainer {

    override open class func defaultDirectoryURL() -> URL {
        let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.rvdubinskiy")
        return storeURL!
    }
}
