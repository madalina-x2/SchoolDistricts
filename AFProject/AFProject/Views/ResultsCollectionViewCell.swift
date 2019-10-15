//
//  ResultsCollectionViewCell.swift
//  AFProject
//
//  Created by Madalina Sinca on 14/10/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit

class ResultsCollectionViewCell: UICollectionReusableView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var resultsLabel: UILabel!
    
   // MARK: - Initializers
    
    func initializeCell(with text: String) {
        resultsLabel.text = text
    }
}
