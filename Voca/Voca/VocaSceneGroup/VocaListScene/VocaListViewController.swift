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
        viewModel.fetch()
    }
    
    @IBAction func didTapEditButton(_ sender: Any) {
        collectionView.isEditing.toggle()
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
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
                print(section)
            }
            .store(in: &subscriptions)
    }
}

//MARK: - CollectionView 관련 함수들
extension VocaListViewController {
    
    private func configureLayout() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
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
            print(transaction)
        }
    }
    
}

//MARK: - UICollectionViewDelegate 관렴 함수
extension VocaListViewController: UICollectionViewDelegate {
}
