//
//  CustomTableViewCell.swift
//  ABBYY
//
//  Created by Roman Dubinskiy on 5/26/19.
//  Copyright © 2019 Roman Dubinskiy. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.sizeToFit()
        label.font = UIFont.init(name: "Comfortaa-Regular", size: 22)
        return label
    }()

    lazy var dateOfCreation: UILabel = {
        var label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.sizeToFit()
        label.textColor = UIColor.gray
        label.font = UIFont.init(name: "Quicksand-Regular", size: 15)
        return label
    }()
    
    lazy var comments: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.sizeToFit()
        label.textColor = UIColor.gray
        label.font = UIFont.init(name: "Comfortaa-Regular", size: 15)
        return label
    }()
    
    lazy var status: UILabel = {
        var label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.sizeToFit()
        label.textColor = UIColor.gray
        label.font = UIFont.init(name: "Quicksand-Regular", size: 15)
        return label
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.addSubview(nameLabel)
        self.addSubview(dateOfCreation)
        self.addSubview(comments)
        self.addSubview(status)
    
        setupConstraints()
    }
    
    func setupConstraints() {
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 22).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2/3).isActive = true
        
        
        //
        dateOfCreation.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        dateOfCreation.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        dateOfCreation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateOfCreation.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        
        //
        comments.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 22).isActive = true
        comments.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        comments.heightAnchor.constraint(equalToConstant: 30).isActive = true
        comments.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 5/10).isActive = true
        //
        
        status.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        status.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        status.heightAnchor.constraint(equalToConstant: 30).isActive = true
        status.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3).isActive = true
        
    }

}
