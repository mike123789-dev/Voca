//
//  ExamListViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/28.
//

import UIKit

enum ExamSection: Int, CaseIterable {
    case favorite
    case folder
}

class ExamListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: DataSource! = nil
    typealias DataSource = UICollectionViewDiffableDataSource<ExamSection, VocaSectionModel>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        dummysnapshot()
    }
    
    func dummysnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ExamSection, VocaSectionModel>()
        snapshot.appendSections([.favorite])
        snapshot.appendItems([TestData.section1, TestData.section2, TestData.section3], toSection: .favorite)
        snapshot.appendSections([.folder])
        snapshot.appendItems([TestData.section2, TestData.section3], toSection: .folder)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}

//MARK: - CollectionView 관련 함수들
extension ExamListViewController {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = generateLayout()
        collectionView.backgroundColor = .systemBackground
        configureDataSource()
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500
            let sectionLayoutKind = ExamSection.allCases[sectionIndex]
            switch (sectionLayoutKind) {
            case .favorite: return self?.generateFavoriteLayout()
            case .folder: return self?.generateFolderLayout(isWide: isWideView)
            }
        }
        return layout
        
    }
    
    private func generateFavoriteLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                               heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
//        section.interGroupSpacing = 20
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func generateFolderLayout(isWide: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                     leading: 2,
                                                     bottom: 2,
                                                     trailing: 2)
        
        let groupHeight = NSCollectionLayoutDimension.fractionalWidth(isWide ? 0.25 : 0.5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: isWide ? 2 : 1)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func configureDataSource() {
        collectionView.register(ExamHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "ExamHeaderCollectionReusableView")
        
        dataSource =
            DataSource(collectionView: collectionView,
                       cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                        let cell = collectionView
                            .dequeueReusableCell(
                                withReuseIdentifier: "ExamCollectionViewCell",
                                for: indexPath) as? ExamCollectionViewCell
                        cell?.configure(with: item)
                        return cell
                       })
        
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            if elementKind == UICollectionView.elementKindSectionHeader {
                let cell = collectionView
                    .dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: "ExamHeaderCollectionReusableView",
                        for: indexPath) as? ExamHeaderCollectionReusableView
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                var sectionTitle = ""
                switch section {
                case .folder:
                    sectionTitle = "폴더"
                case .favorite:
                    sectionTitle = "즐겨찾기"
                }
                cell?.configure(title: sectionTitle
                )
                return cell
            } else {
                return nil
            }
        }
        
    }
}

extension ExamListViewController: UICollectionViewDelegate {
    
}
