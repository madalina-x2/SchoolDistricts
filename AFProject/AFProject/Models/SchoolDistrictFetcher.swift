//
//  SchoolDistrictFetcher.swift
//  AFProject
//
//  Created by Madalina Sinca on 14/10/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import Foundation
import Alamofire

class SchoolDistrictFetcher {
    
    var schoolDistricts: [SchoolDistrict] = []
    var jsonURL = URL(string: "https://launchpad-169908.firebaseio.com/schools.json")
    let group = DispatchGroup()
    
    // MARK: - Class Methods
    
    func getOrderedSchoolDistricts() -> [SchoolDistrict] {
        getJsonObjects(from: jsonURL!)
        
        return schoolDistricts.sortAlphabetically(by: \.district)
    }
    
    private func getJsonObjects(from url: URL) {
        Alamofire.request(url,
                          method: .get,
                          parameters: nil)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("error while fetching school districts: \(String(describing: response.result.error))")
                    return
                }
                guard let value = response.result.value as? [String: Any] else {
                    print("malformed JSON")
                    return
                }
                
                self.schoolDistricts = Array(value.mapValues {
                    return SchoolDistrict(jsonData: $0 as! [String: Any])
                }.values)
                print()
        }
    }
}

