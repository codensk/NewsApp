//
//  CategoryCollectionViewController.swift
//  NewsApp
//
//  Created by SERGEY VOROBEV on 25.06.2021.
//

import UIKit

class CategoryCollectionViewController: UICollectionViewController {
    private let categories = Category.getCategories()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // MARK: - Methods
    private func setup() {
        overrideUserInterfaceStyle = .light
        
        collectionView.collectionViewLayout = createViewCollectionCompositionalLayout()
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    private func createViewCollectionCompositionalLayout() -> UICollectionViewLayout {
        let leadingTrailingSpace: CGFloat = 10
        let topBottomSpace: CGFloat = 5
        let groupHeight: CGFloat = 85
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = .init(top: topBottomSpace, leading: leadingTrailingSpace, bottom: topBottomSpace, trailing: leadingTrailingSpace)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(groupHeight + (topBottomSpace * 2)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

// MARK: - UICollectionViewDataSource
extension CategoryCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.row]

        cell.configureCategoryCellView()

        cell.categoryNameLabel.text = category.categoryName
        cell.categoryImageView.image = UIImage(named: category.categoryCode)

        return cell
    }
}

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HeaderCollectionView else {
            return UICollectionReusableView()
        }
        
        return headerView
        
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "newsVC") as? NewsTableViewController else {
            return
        }
        
        let selectedCategory = categories[indexPath.row]
        
        vc.fetchNewsList(for: selectedCategory)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
