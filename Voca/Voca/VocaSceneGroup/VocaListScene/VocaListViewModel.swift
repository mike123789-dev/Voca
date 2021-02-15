//
//  VocaListViewModel.swift
//  Voca
//
//  Created by 강병민 on 2021/01/20.
//

import Foundation
import UIKit
import Combine
import CoreData

enum VocaItem: Hashable {
    case parent(Section)
    case child(Voca)
}

enum Section: Hashable {
    case search
    case favorite(count: Int)
    case folder(count: Int, title: String)
}

class VocaListViewModel: NSObject {
    enum Mode {
        case search, favorite, folder
    }
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, VocaItem>
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<VocaItem>
    
    let coreDataStack: CoreDataStack
    var currentSearchText = ""
    var predicate: NSPredicate?
    var vocaSectionFetchedController: NSFetchedResultsController<VocaSection>!
    var vocaFetchedController: NSFetchedResultsController<Voca>!

    let snapshotPublisher = PassthroughSubject<Snapshot, Never>()
    let sectionSnapshotPublisher = PassthroughSubject<(SectionSnapshot, Section), Never>()
    let vocaUpdatePublisher = PassthroughSubject<(IndexPath, Voca), Never>()
    
    var isShowingFavorites = false {
        didSet {
            print("showing favorites \(isShowingFavorites)")
        }
    }
    var currentMode: Mode = .folder
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func fetchData() {
        loadSavedData()
    }
    
    private func loadSavedData() {
        if vocaSectionFetchedController == nil {
            let request = VocaSection.createFetchRequest()
            let sort = NSSortDescriptor(key: "date", ascending: true)
            request.sortDescriptors = [sort]
            vocaSectionFetchedController =
                NSFetchedResultsController(fetchRequest: request,
                                           managedObjectContext: coreDataStack.managedContext,
                                           sectionNameKeyPath: nil,
                                           cacheName: nil)
            vocaSectionFetchedController.delegate = self
            if !currentSearchText.isEmpty {
                request.predicate = NSPredicate(format: "vocas.question CONTAINS[c] %@", currentSearchText)
            }
        }
        vocaSectionFetchedController.fetchRequest.predicate = predicate
        
        do {
            try vocaSectionFetchedController.performFetch()
            updateSnapshot()
        } catch {
            print("Fetch failed")
        }
    }
    
    private func loadSearchedVocas() {
        let request = Voca.createFetchRequest()
        request.fetchBatchSize = 30
        request.predicate = NSPredicate(format: "question CONTAINS[c] %@ OR answer CONTAINS[c] %@", currentSearchText, currentSearchText)
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        
        vocaFetchedController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        vocaFetchedController.delegate = self
        
        do {
            try vocaFetchedController.performFetch()
            updateSearchSnapshot()
        } catch {
            print("Fetch failed")
        }
    }
    
}
extension VocaListViewModel {
    func delete(_ item: VocaItem) {
        switch item {
        case .child(let voca):
            coreDataStack.managedContext.delete(voca)
        case .parent(let section):
            break
            //TODO: 폴더 지우기
//            coreDataStack.managedContext.delete(section)
//            updateSnapshot()
        }
        coreDataStack.saveContext()
    }
    
    func toggleFavorite(at indexPath: IndexPath) {
        switch currentMode {
        case .folder:
            guard let section = vocaSectionFetchedController.fetchedObjects?[indexPath.section] else { return }
            let voca = section.vocaArray[indexPath.row - 1]
            voca.isFavorite.toggle()
            coreDataStack.saveContext()
            vocaUpdatePublisher.send((indexPath, voca))
        case .search:
            let index = IndexPath(row: indexPath.row - 1,
                                  section: indexPath.section)
            let voca = vocaFetchedController.object(at: index)
            voca.isFavorite.toggle()
            coreDataStack.saveContext()
            vocaUpdatePublisher.send((indexPath, voca))
        default:
            break
        }
    }
    
    func update(_ voca: Voca, question: String, answer: String, at indexPath: IndexPath) {
        voca.question = question
        voca.answer = answer
        coreDataStack.saveContext()
        vocaUpdatePublisher.send((indexPath, voca))
    }
    
    func addFolder(title: String) {
        let s = VocaSection(context: coreDataStack.managedContext)
        s.date = Date()
        s.title = title
        s.id = UUID()
        coreDataStack.saveContext()
        updateSnapshot()
    }
    
    func addVocas(_ vocas: [(question: String, answer: String)], to folder: String) {
        let section = vocaSectionFetchedController.fetchedObjects?.first(where: { section -> Bool in
            section.title == folder
        })
        vocas.forEach { voca in
            let v = Voca(context: coreDataStack.managedContext)
            v.answer = voca.answer
            v.question = voca.question
            v.correctCount = 0
            v.wrongCount = 0
            v.isFavorite = false
            v.date = Date()
            v.id = UUID()
            section?.addToVocas(v)
        }
        coreDataStack.saveContext()
        updateSnapshot()
    }
    
}

extension VocaListViewModel: NSFetchedResultsControllerDelegate {
    
    private func updateSnapshot() {
        guard let vocaSections = vocaSectionFetchedController.fetchedObjects else { return }
        let sections = vocaSections.map { Section.folder(count: $0.vocas.count, title: $0.title) }
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        snapshotPublisher.send(snapshot)
        
        for (index, section) in vocaSections.enumerated() {
            var sectionSnapshot = SectionSnapshot()
            let header = VocaItem.parent(Section.folder(count: 0, title: section.title))
            sectionSnapshot.append([header])
            sectionSnapshot.append(
                section.vocaArray.map {  VocaItem.child($0) },
                to: header
            )
            sectionSnapshot.expand([header])
            sectionSnapshotPublisher.send((sectionSnapshot, sections[index]))
        }
    }

    private func updateSearchSnapshot() {
        guard let vocas = vocaFetchedController.fetchedObjects else { return }
        var snapshot = Snapshot()
        snapshot.appendSections([.search])
        
        snapshotPublisher.send(snapshot)
        var sectionSnapshot = SectionSnapshot()
        let searchSection = Section.search
        let header = VocaItem.parent(searchSection)
        sectionSnapshot.append([header])
        sectionSnapshot.append(
            vocas.map { VocaItem.child($0) },
            to: header
        )
        sectionSnapshot.expand([header])
        sectionSnapshotPublisher.send((sectionSnapshot, searchSection))
    }

}

extension VocaListViewModel: VocaAddDelegate {
    func didAdd(_ vocas: [(String, String)], to folder: String) {
        addVocas(vocas, to: folder)
    }
}

//MARK: - Search 관련 함수들
extension VocaListViewModel: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        currentSearchText = text
        if searchController.isActive {
            currentMode = .search
            loadSearchedVocas()
        } else {
            currentMode = .folder
            loadSavedData()
        }
    }
}
