//
//  VocaListViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/20.
//

import UIKit
import Combine

class VocaListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: DataSource! = nil
    typealias DataSource = UICollectionViewDiffableDataSource<VocaSection, VocaItem>
    
    let viewModel = VocaListViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureBinding()
        viewModel.setup()
    }
    
    @IBAction func didTapEditButton(_ sender: Any) {
        collectionView.isEditing.toggle()
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.allowsSelectionDuringEditing = false
        collectionView.allowsSelectionDuringEditing = false
        configureLayout()
        configureDataSource()
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
    }
}

//MARK: - CollectionView 관련 함수들
extension VocaListViewController {
    
    private func configureLayout() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.trailingSwipeActionsConfigurationProvider = { [weak self] (indexPath) in
            guard let item = self?.dataSource?.itemIdentifier(for: indexPath),
                  let self = self else {
                return nil
            }
            let deleteAction = UIContextualAction(style: .destructive, title: "제거") { (action, _, completion) in
                
                var snapShot = self.dataSource.snapshot()
                snapShot.deleteItems([item])
                self.dataSource.apply(snapShot)
                self.viewModel.delete(item)
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        configuration.leadingSwipeActionsConfigurationProvider = { [weak self] (indexPath) in
            guard let item = self?.dataSource?.itemIdentifier(for: indexPath) else {
                return nil
            }
            let favoriteAction = UIContextualAction(style: .normal, title: nil) { (action, _, completion) in
//                코어 데이터에서 좋아요 toggle
//                self?.handleSwipe(for: action, item: item)
                completion(true)
            }
            favoriteAction.image = UIImage(named: "person")
            favoriteAction.backgroundColor = .systemOrange
            return UISwipeActionsConfiguration(actions: [favoriteAction])
        }

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureDataSource() {
        
        let parentCell = UICollectionView.CellRegistration<UICollectionViewListCell, VocaSection> { cell, _, item in
            
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
            
            let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options:headerDisclosureOption)]
        }
        
        dataSource = DataSource(collectionView: collectionView,
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
        
        dataSource.reorderingHandlers.canReorderItem = { item in true}
        dataSource.reorderingHandlers.didReorder = { transaction in
        }
    }
    
}

//MARK: - UICollectionViewDelegate 관렴 함수
extension VocaListViewController: UICollectionViewDelegate {
}
