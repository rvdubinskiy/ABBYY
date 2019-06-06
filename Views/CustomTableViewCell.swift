//
//  CustomTableViewCell.swift
//  ABBYY
//
//  Created by Roman Dubinskiy on 5/26/19.
//  Copyright © 2019 Roman Dubinskiy. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    lazy var backView: UIView = {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 80))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let nameLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.sizeToFit()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    lazy var dateOfCreation: UILabel = {
        var label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.sizeToFit()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var comments: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.sizeToFit()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var status: UILabel = {
        var label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.sizeToFit()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        addSubview(backView)
        backView.addSubview(nameLabel)
        backView.addSubview(dateOfCreation)
        backView.addSubview(comments)
        backView.addSubview(status)
        
        setupConstraints()
        
        
        // Configure the view for the selected state
    }
    
    func setupConstraints() {
        nameLabel.leftAnchor.constraint(equalTo: self.backView.leftAnchor, constant: 22).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.backView.topAnchor, constant: 12).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.backView.widthAnchor, multiplier: 2/3).isActive = true
        
        
        //
        dateOfCreation.rightAnchor.constraint(equalTo: self.backView.rightAnchor, constant: -20).isActive = true
        dateOfCreation.topAnchor.constraint(equalTo: self.backView.topAnchor, constant: 12).isActive = true
        dateOfCreation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateOfCreation.widthAnchor.constraint(equalTo: self.backView.widthAnchor, multiplier: 1/3).isActive = true
        
        //
        comments.leftAnchor.constraint(equalTo: self.backView.leftAnchor, constant: 22).isActive = true
        comments.bottomAnchor.constraint(equalTo: self.backView.bottomAnchor, constant: -8).isActive = true
        comments.heightAnchor.constraint(equalToConstant: 30).isActive = true
        comments.widthAnchor.constraint(equalTo: self.backView.widthAnchor, multiplier: 5/10).isActive = true
        //
        
        status.rightAnchor.constraint(equalTo: self.backView.rightAnchor, constant: -20).isActive = true
        status.bottomAnchor.constraint(equalTo: self.backView.bottomAnchor, constant: -8).isActive = true
        status.heightAnchor.constraint(equalToConstant: 30).isActive = true
        status.widthAnchor.constraint(equalTo: self.backView.widthAnchor, multiplier: 1/3).isActive = true
        
    }

}
