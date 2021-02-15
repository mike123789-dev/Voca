//
//  ExamListViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/28.
//

import UIKit
import Combine

class ExamListViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var coordinator: ExamListCoordinator?
    let viewModel: ExamListViewModel
    var subscriptions = Set<AnyCancellable>()
    private var dataSource: DataSource! = nil
    typealias DataSource = UICollectionViewDiffableDataSource<ExamSection, CategorizedSection>

    init?(coder: NSCoder, viewModel: ExamListViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a user.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationController()
        configureBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.performWithoutAnimation {
          viewModel.fetchData()
        }
    }
    
    private func configureBinding() {
        viewModel.snapshotPublisher
            .sink { [weak self] snapshot in
                guard let self = self else { return }
                self.dataSource.apply(snapshot)
            }
            .store(in: &subscriptions)
    }
}

//MARK: - CollectionView 관련 함수들
extension ExamListViewController {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.collectionViewLayout = generateLayout()
        collectionView.backgroundColor = .systemGroupedBackground
        configureDataSource()
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let layout =
            UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500
            let sectionLayoutKind = ExamSection.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .favorite:
                return self?.generateFavoriteLayout()
            case .folder:
                return self?.generateFolderLayout(isWide: isWideView)
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                        leading: 0,
                                                        bottom: 16,
                                                        trailing: 0)
        
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
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        //        sectionHeader.pinToVisibleBounds = true
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
                        switch item {
                        case .favorite(let section):
                        cell?.configure(with: section)
                        case .folder(let section):
                            cell?.configure(with: section)
                        }
                        return cell
                       })
        
        dataSource.supplementaryViewProvider
            = { [unowned self] (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let folder = dataSource.itemIdentifier(for: indexPath) {
//            coordinator?.showExam(with: folder)
        }
    }
}

extension ExamListViewController {
    
    func configureNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemGroupedBackground
    }
    
}
