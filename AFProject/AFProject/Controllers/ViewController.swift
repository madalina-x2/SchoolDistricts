//
//  ViewController.swift
//  AFProject
//
//  Created by Madalina Sinca on 08/10/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    var schoolDistricts: [SchoolDistrict]?
    var url = URL(string: "https://launchpad-169908.firebaseio.com/schools.json")
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSchoolDistricts(url: url!)
    }
    
    // MARK: - Class Methods
    
    func fetchSchoolDistricts(url: URL) {
        Alamofire.request(url,
                          method: .get,
                          parameters: nil)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("error while fetching school districts: \(String(describing: response.result.error))")
                    return
                }
                print("\(String(describing: response.result.value))")
                
                guard let value = response.result.value as? [String: Any] else {
                    print("malformed JSON")
                    return
                }
                
                self.schoolDistricts = Array(value.mapValues { return SchoolDistrict(jsonData: $0 as! [String: Any]) }.values) // ios_enabled == true filter?
        }
    }
}


