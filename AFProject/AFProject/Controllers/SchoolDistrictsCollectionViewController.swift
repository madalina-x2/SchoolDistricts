//
//  SchoolDistrictsCollectionViewController.swift
//  AFProject
//
//  Created by Madalina Sinca on 10/10/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let reuseIdentifier = "schoolDistrictCell"

class SchoolDistrictsCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var searchIconImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchBar: UITextField! {
        didSet {
            searchBar.addTarget(self,
                                action: #selector(queryDidChange(_:)),
                                for: .editingChanged)
        }
    }
    
    // MARK: - Properties
    
    var schoolDistrictFetcher = SchoolDistrictFetcher()
    var allSchoolDistricts: [SchoolDistrict]? {
        didSet {
            filteredSchoolDistricts = allSchoolDistricts
        }
    }
    var filteredSchoolDistricts: [SchoolDistrict]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private var itemWidth: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return (view.bounds.width - 30) / 2
        }
        return view.bounds.width - 20
    }
    private var itemHeight: CGFloat = 80

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupContainerView()
        
        collectionView.contentInset.left = 10
        collectionView.contentInset.right = 10
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        schoolDistrictFetcher.getOrderedSchoolDistrictsWith { (result) in
            if case let (.failure(error)) =  result {
                print(error)
                return
            }
            self.allSchoolDistricts = try? result.get()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.contentInset.top = containerView.frame.maxY + 10
    }
    
    // MARK: - Auxiliary Methods
    
    func setupContainerView() {
        containerView.makeRoundedCorners(cornerRadius: 10)
        searchIconImage.image = #imageLiteral(resourceName: "searchIcon")
    }
        
    @objc func queryDidChange(_ sender: UITextField) {
        filteredSchoolDistricts = filterSchoolDistricts(by: sender.text!)
        print("")
    }
    
    private func filterSchoolDistricts(by query: String) -> [SchoolDistrict] {
        if query == "" {
            return allSchoolDistricts!
        }
        var results = [SchoolDistrict]()
        
        results = allSchoolDistricts!.filter{ $0.district.lowercased().contains(query.lowercased())}
        return results
    }
}

// MARK: UICollectionViewDataSource extension

extension SchoolDistrictsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredSchoolDistricts?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SchoolDistrictCollectionViewCell else {
            fatalError("Could not get cell.")
        }
        guard let schoolDistrict = filteredSchoolDistricts?[indexPath.item] else {
            return cell
        }
        let thumbnailURL = schoolDistrict.logoURLThumbnail
        let districtName = schoolDistrict.district
        let stateName = schoolDistrict.state
        let isBackgroundBlue = schoolDistrict.blueBackground
        
        cell.populateWith(url: thumbnailURL, stateLabel: stateName, districtLabel: districtName)
        cell.assignCellStyle(imageContainerColor: isBackgroundBlue)

        return cell
    }
}

// MARK: - CollectionView FlowLayout Delegate Extension

extension SchoolDistrictsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
