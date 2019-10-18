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
    
    // MARK: - Private Properties
    
    private let jsonURL = URL(string: "https://launchpad-169908.firebaseio.com/schools.json")
    
    // MARK: - Fetcher
    
    func getOrderedSchoolDistrictsWith(completion: @escaping (Swift.Result<[SchoolDistrict], Error>) -> ()) {
        getAlphabeticallyOrderedJsonObjects(from: jsonURL!, completion: completion)
    }
    
    // MARK: - Network Handling
    
    private func getAlphabeticallyOrderedJsonObjects(from url: URL, completion: @escaping (Swift.Result<[SchoolDistrict], Error>) -> ()) {
        Alamofire.request(url,
                          method: .get,
                          parameters: nil)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    completion(.failure(response.result.error!))
                    return
                }
                guard let value = response.result.value as? [String: Any] else {
                    completion(.failure(FetchError(message: "Malformed json")))
                    return
                }
                
                let schoolDistricts = Array(value.mapValues {
                    return SchoolDistrict(jsonData: $0 as! [String: Any])
                }.values).filter{ $0.district.contains("#") == false}
                
                completion(.success(schoolDistricts.sortAlphabetically(by: \.district)))
        }
    }
}

// MARK: - Extensions

extension SchoolDistrictFetcher {
    struct FetchError: Error {
        let message: String
        var localizedDescription: String {
            return message
        }
    }
}
