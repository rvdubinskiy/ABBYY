//
//  TaskInfo.swift
//  ABBYY
//
//  Created by Roman Dubinskiy on 6/4/19.
//  Copyright © 2019 Roman Dubinskiy. All rights reserved.
//

import Foundation
import UIKit

struct TaskInfo {
    lazy var nameOfTask: UITextField = {
        var field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.masksToBounds = true
        field.text = "New Task"
        field.font = UIFont.boldSystemFont(ofSize: 22)
        return field
    }()
    
    lazy var comment: UITextView = {
        var text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.masksToBounds = true
        text.sizeToFit()
        text.font = UIFont.systemFont(ofSize: 15)
        text.text = "Enter the comments for your task"
        return text
    }()
    
    lazy var createButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.setTitle("Create task", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return button
    }()

    lazy var finishTask: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.setTitle("Finish", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return button
    }()
    
    lazy var statusFiels: UITextField = {
        var field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.masksToBounds = true
        field.text = "Status: new"
        field.font = UIFont.boldSystemFont(ofSize: 17)
        field.textColor = UIColor.gray
        field.textAlignment = .center
        return field
    }()
    
}
