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
    var logoURL: String
    var logoURLThumbnail: String
    
    // MARK: - Initializers
    
    init(jsonData: [String: Any]) {
        self.district = jsonData["district"] as? String ?? "NA"
        self.state = jsonData["state"] as? String ?? "NA"
        self.logoURL = jsonData["logo_url"] as? String ?? "NA"
        self.logoURLThumbnail = jsonData["logo_url_thumbnail"] as? String ?? "NA"
    }
}
