//
//  CompanyCell.swift
//  IntermediateTraining
//
//  Created by Joffrey Fortin on 08/03/2018.
//  Copyright © 2018 myCode. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    var company: Company? {
        didSet {
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            } else if let photoUrl = company?.photoUrl {
                
                if let imageURL = URL(string: photoUrl) {
                    // just not to cause a deadlock in UI!
                    DispatchQueue.global().async {
                        guard let imageData = try? Data(contentsOf: imageURL) else { return }
                        
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.companyImageView.image = image
                        }
                    }
                }
            }
            
            if let name = company?.name, let founded = company?.founded {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, yyyy"
                let foundedDateString = dateFormatter.string(from: founded)
                let dateString = "\(name) - Founded: \(foundedDateString)"
                nameFoundeDateLabel.text = dateString
            } else {
                nameFoundeDateLabel.text = company?.name
            }
        }
    }
    
    // you cannot declare another image view using "imageView"
    let companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    let nameFoundeDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Company name"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.tealColor
        
        [companyImageView, nameFoundeDateLabel].forEach {
            addSubview($0)
        }
        
        companyImageView.anchor(left: leftAnchor, top: nil, right: nil, bottom: nil, leftPadding: 16, topPadding: 0, rightPadding: 0, bottomPadding: 0, width: 40, height: 40)
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        nameFoundeDateLabel.anchor(left: companyImageView.rightAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftPadding: 8, topPadding: 0, rightPadding: 0, bottomPadding: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
