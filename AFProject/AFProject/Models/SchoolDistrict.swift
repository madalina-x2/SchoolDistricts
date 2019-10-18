//
//  SchoolDistrict.swift
//  AFProject
//
//  Created by Madalina Sinca on 09/10/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation

struct SchoolDistrict {
    
    // MARK: - Properties
    
    var district: String
    var state: String
    var logoURLThumbnail: URL
    var blueBackground: Bool
    
    // MARK: - Initializers
    
    init(jsonData: [String: Any]) {
        self.district = jsonData["district"] as? String ?? "NA"
        self.state = jsonData["state"] as? String ?? "NA"
        self.logoURLThumbnail = URL(string: jsonData["logo_url_thumbnail"] as? String ?? "NA")!
        self.blueBackground = jsonData["background"] as? Bool ?? false
    }
}

