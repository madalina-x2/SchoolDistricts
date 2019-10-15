//
//  SchoolDistrictsCollectionViewController.swift
//  AFProject
//
//  Created by Madalina Sinca on 10/10/2019.
//  Copyright © 2019 Madalina Sinca. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "schoolDistrictCell"

class SchoolDistrictsCollectionViewController: UIViewController {
    
    // MARK: - Constants
    
    struct Constants {
        static let collectionViewCellHeight: CGFloat = 80
        static let sideContentInset: CGFloat = 10
        static let interItemSpacing: CGFloat = 10
        static let reusableViewHeightOffset: CGFloat = 30
        
        static let cornerRadius: CGFloat = 10
    }

    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var searchIconImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchBar: UITextField! {
        didSet {
            searchBar.addTarget(self,
                                action: #selector(queryDidChange(_:)),
                                for: .editingChanged)
            searchBar.becomeFirstResponder()
        }
    }
    
    // MARK: - Properties
    
    private var schoolDistrictFetcher = SchoolDistrictFetcher()
    private var allSchoolDistricts: [SchoolDistrict]? {
        didSet {
            filteredSchoolDistricts = allSchoolDistricts
        }
    }
    private var filteredSchoolDistricts: [SchoolDistrict]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private var itemWidth: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return (view.bounds.width - Constants.sideContentInset * 2 - Constants.interItemSpacing) / 2
        }
        return view.bounds.width - Constants.sideContentInset * 2
    }
    private var itemHeight: CGFloat = Constants.collectionViewCellHeight
    private var shouldDisplayResultsHeader: Bool! {
        if allSchoolDistricts?.count == filteredSchoolDistricts?.count {
            return false
        }
        return true
    }

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupContainerView()
        
        collectionView.contentInset.left = Constants.sideContentInset
        collectionView.contentInset.right = Constants.sideContentInset
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing = Constants.interItemSpacing
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
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.contentInset.top = containerView.frame.maxY + Constants.sideContentInset
    }
    
    // MARK: - UICollectionReusableView Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind != UICollectionView.elementKindSectionHeader {
           fatalError("Not a header.")
        }
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reusableHeaderView", for: indexPath) as? ResultsCollectionViewCell else {
            fatalError("Could not get cell.")
        }
        let resultString = filteredSchoolDistricts?.count == 1 ? "1 Result found" : "\(filteredSchoolDistricts?.count ?? 0)" + " Results found"
        cell.initializeCell(with: resultString)
        
        return cell
    }
    
    // MARK: - UIScrollView Delegate Methods
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Auxiliary Methods
    
    func setupContainerView() {
        containerView.makeRoundedCorners(cornerRadius: Constants.cornerRadius)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if shouldDisplayResultsHeader {
            return CGSize(width: view.bounds.width + Constants.sideContentInset * 2, height: itemHeight - Constants.reusableViewHeightOffset)
        }
        return CGSize.zero
    }
}
