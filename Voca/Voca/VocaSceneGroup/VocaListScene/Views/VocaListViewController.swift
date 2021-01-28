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
    @Published var isEditMode = false
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationController()
        configureBinding()
        viewModel.setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isEditMode = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        switch segueId {
        case "VocaAddViewController":
            guard let addVC = segue.destination as? VocaAddViewController  else { return }
            addVC.viewModel.folders = dataSource.snapshot().sectionIdentifiers
            addVC.viewModel.delegate = viewModel
        default:
            break
        }
    }
    
    @IBAction func didTapEditButton(_ sender: Any) {
        isEditMode.toggle()
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
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
        $isEditMode
            .sink { [weak self] isEditMode in
                self?.collectionView.isEditing = isEditMode
                self?.navigationController?.setToolbarHidden(!isEditMode, animated: true)
            }
            .store(in: &subscriptions)
    }
    
    @objc
    func didTapAddFolderButton() {
        let alert = CustomAlertViewController(type: .addVoca)
        alert.textHandler = { [weak self] inputText in
            self?.viewModel.addFolder(title: inputText)
        }
        self.present(alert, animated: true)
    }
    
    @objc
    func didTapFavoriteButton() {
        //TODO: 좋아요 기능 추가
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
                  let self = self else {
                return nil
            }
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

//MARK: - NavigationContoller 관련 함수
extension VocaListViewController {
    
    func configureNavigationController() {
        //        UIBarButtonItem(
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
                                        action: #selector(didTapAddFolderButton))
        toolbarItems = [addFolder, spacer, favorites]
    }
    
}

//MARK: - UICollectionViewDelegate 관렴 함수
extension VocaListViewController: UICollectionViewDelegate {
}
