//
//  SchoolDistrictCollectionViewCell.swift
//  AFProject
//
//  Created by Madalina Sinca on 10/10/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit
import Kingfisher

class SchoolDistrictCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var schoolDistrictLogo: UIImageView!
    @IBOutlet weak var schoolDistrictStateLabel: UILabel!
    @IBOutlet weak var schoolDistrictNameLabel: UILabel!
    @IBOutlet weak var imageContainerView: UIView!
        
    // MARK: - Class Methods
    
    func populateWith(url: URL, stateLabel: String, districtLabel: String) {
        schoolDistrictNameLabel.text = districtLabel
        schoolDistrictStateLabel.text = stateLabel
        schoolDistrictLogo.kf.setImage(with: url)
    }
    
    func assignCellStyle(imageContainerColor: Bool = false) {
        self.makeRoundedCorners(cornerRadius: 10)
        self.dropShadow()
        imageContainerView.makeRoundedCorners(cornerRadius: 20)
        imageContainerView.backgroundColor = imageContainerColor == true ? #colorLiteral(red: 0.1944874823, green: 0.6455144286, blue: 0.7794849277, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
