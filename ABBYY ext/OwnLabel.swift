//
//  Prototype.swift
//  ABBYY
//
//  Created by Roman Dubinskiy on 6/4/19.
//  Copyright © 2019 Roman Dubinskiy. All rights reserved.
//

import Foundation
import UIKit

class OwnLabel {
    var label: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        return label
    }()
}
