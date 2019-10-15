//
//  ResultsCollectionViewCell.swift
//  AFProject
//
//  Created by Madalina Sinca on 14/10/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class ResultsCollectionViewCell: UICollectionReusableView {
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    func initializeCell(with color: CGColor, text: String) {
        resultsLabel.text = text
    }
}
