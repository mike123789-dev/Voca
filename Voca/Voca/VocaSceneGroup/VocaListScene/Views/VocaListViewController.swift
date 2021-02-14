//
//  VocaListViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/20.
//

import UIKit
import Combine

class VocaListViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: DataSource! = nil
    typealias DataSource = UICollectionViewDiffableDataSource<Section, VocaItem>
    private var searchController = UISearchController(searchResultsController: nil)

    weak var coordinator: VocaListCoordinator?
    let viewModel = VocaListViewModel()
    @Published var isEditMode = false
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationController()
        configureSearchController()
        configureBinding()
        UIView.performWithoutAnimation {
          viewModel.fetchData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isEditMode = false
    }
    
    @IBAction func didTapEditButton(_ sender: Any) {
        isEditMode.toggle()
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        let folders = dataSource.snapshot().sectionIdentifiers.map({ section -> String? in
            switch section {
            case .folder(count: _, title: let title):
                return title
            case .favorite(count: _):
                return nil
            case .search:
                return nil
            }
        })
        coordinator?.showAdd(with: folders.compactMap { $0 }, viewModel: viewModel)
    }
    
    private func configureBinding() {
        viewModel.snapshotPublisher
            .sink { [weak self] snapshot in
                guard let self = self else { return }
                self.dataSource.apply(snapshot)
            }
            .store(in: &subscriptions)
        viewModel.sectionSnapshotPublisher
            .sink { [weak self] sectionSnapshot, section in
                guard let self = self else { return }
                self.dataSource.apply(sectionSnapshot, to: section, animatingDifferences: true)
            }
            .store(in: &subscriptions)
        viewModel.vocaUpdatePublisher
            .sink { [weak self] indexPath, voca in
                guard let self = self else { return }
                let cell = self.collectionView.cellForItem(at: indexPath) as? VocaCollectionViewCell
                cell?.configure(with: voca)
            }
            .store(in: &subscriptions)
        $isEditMode
            .sink { [weak self] isEditMode in
                self?.collectionView.isEditing = isEditMode
                self?.navigationController?.setToolbarHidden(!isEditMode, animated: true)
            }
            .store(in: &subscriptions)
    }
    
    @objc
    func didTapAddFolderButton() {
        coordinator?.showAddFolderAlert(viewModel: viewModel)
    }
    
    @objc
    func didTapFavoriteButton() {
        //TODO: 좋아요 필터링 기능 추가
        viewModel.isShowingFavorites.toggle()
    }
    
}

//MARK: - CollectionView 관련 함수들
extension VocaListViewController {
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.allowsSelectionDuringEditing = false
        collectionView.allowsSelectionDuringEditing = false
        configureLayout()
        configureDataSource()
    }
    
    private func configureLayout() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        
        configuration.trailingSwipeActionsConfigurationProvider = { [weak self] (indexPath) in
            guard let item = self?.dataSource?.itemIdentifier(for: indexPath),
                  let self = self else { return nil }
            
            let deleteAction = UIContextualAction(style: .destructive, title: "제거") { (_, _, completion) in
                var snapShot = self.dataSource.snapshot()
                snapShot.deleteItems([item])
                self.dataSource.apply(snapShot)
                self.viewModel.delete(item)
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        
        configuration.leadingSwipeActionsConfigurationProvider = { [weak self] (indexPath) in
            
            guard let item = self?.dataSource?.itemIdentifier(for: indexPath),
                  let self = self else { return nil }

            let favoriteAction = UIContextualAction(style: .normal, title: "즐겨찾기") { (_, _, completion) in
                self.viewModel.toggleFavorite(at: indexPath)
                completion(true)
            }
            favoriteAction.image = UIImage(systemName: "star.fill")
            favoriteAction.backgroundColor = .systemOrange
            
            let modifyAction = UIContextualAction(style: .normal, title: "수정") { (_, _, completion) in
                switch item {
                case .parent(_):
                    break
                case .child(let voca):
                    self.coordinator?.showModifyVocaAlert(voca: voca, viewModel: self.viewModel, at: indexPath)
                }
                completion(true)
            }
            modifyAction.image = nil
            modifyAction.backgroundColor = .systemBlue
            
            switch item {
            case .parent(_):
                return UISwipeActionsConfiguration(actions: [])
            case .child(_):
                return UISwipeActionsConfiguration(actions: [favoriteAction, modifyAction])
            }
            
        }
        configuration.headerMode = .firstItemInSection
        configuration.footerMode = .supplementary
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureDataSource() {
        
        let parentCell = UICollectionView.CellRegistration<UICollectionViewListCell, Section> { cell, _, section in
            var content = cell.defaultContentConfiguration()
            switch section {
            case .folder(count: _, title: let title):
                content.text = title
                let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
                cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
            case .favorite(count: let count):
                content.text = "즐겨찾기"
                cell.accessories = []
            case .search:
                cell.accessories = []
                break
            }
            cell.contentConfiguration = content
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionFooter) { [unowned self] (footerView, _, indexPath) in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            var configuration = footerView.defaultContentConfiguration()
            switch section {
            case .folder(count: let count, title: _):
                // Configure footer view content
                configuration.text = "단어 수: \(count)"
                configuration.textProperties.alignment = .center
            case .favorite(count: let count):
                configuration.text = "단어 수: \(count)"
                configuration.textProperties.alignment = .center
                configuration.text = nil
            case .search:
                configuration.text = nil
            }
            footerView.contentConfiguration = configuration
        }
        
        dataSource =
            DataSource(collectionView: collectionView,
                       cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                        switch item {
                        case .parent(let parentItem):
                            let cell = collectionView
                                .dequeueConfiguredReusableCell(using: parentCell,
                                                               for: indexPath,
                                                               item: parentItem)
                            return cell
                        case .child(let childItem):
                            let cell = collectionView
                                .dequeueReusableCell(
                                    withReuseIdentifier: "VocaCollectionViewCell",
                                    for: indexPath) as? VocaCollectionViewCell
                            cell?.configure(with: childItem)
                            return cell
                        }
                       })
        
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            if elementKind == UICollectionView.elementKindSectionFooter {
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: footerRegistration, for: indexPath)
            } else {
                return nil
            }
        }
        
        dataSource.reorderingHandlers.canReorderItem = { item in true}
        dataSource.reorderingHandlers.didReorder = { transaction in
            print(transaction.difference)
            //TODO: Reorder 구현
        }
    }
    
}

//MARK: - NavigationContoller 관련 함수
extension VocaListViewController {
    
    func configureNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let addFolder = UIBarButtonItem(title: "폴더 추가",
                                        style: .plain,
                                        target: self,
                                        action: #selector(didTapAddFolderButton))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                     target: self,
                                     action: nil)
        let favorites = UIBarButtonItem(title: "즐쳐찾기",
                                        style: .plain,
                                        target: self,
                                        action: #selector(didTapFavoriteButton))
        toolbarItems = [addFolder, spacer, favorites]
    }
    
}
//MARK: - Search 관련 함수
extension VocaListViewController {
    private func configureSearchController() {
        searchController.searchResultsUpdater = self.viewModel
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "단어 찾기"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

//MARK: - UICollectionViewDelegate 관렴 함수
extension VocaListViewController: UICollectionViewDelegate {
}
