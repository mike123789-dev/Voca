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
    case parent(VocaSection)
    case child(Voca)
}

enum Section: Hashable {
    case favorite(count: Int)
    case folder(count: Int, title: String)
}

class VocaListViewModel: NSObject {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, VocaItem>
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<VocaItem>
    
    lazy var coreDataStack = CoreDataStack(modelName: "Voca")
    var currentSearchText = ""
    var predicate: NSPredicate?
    var fetchedResultsController: NSFetchedResultsController<VocaSection>!
    
    let snapshotPublisher = PassthroughSubject<Snapshot, Never>()
    let sectionSnapshotPublisher = PassthroughSubject<(SectionSnapshot, Section), Never>()
    let vocaUpdatePublisher = PassthroughSubject<(IndexPath, Voca), Never>()
    
    var isShowingFavorites = false {
        didSet {
            print("showing favorites \(isShowingFavorites)")
        }
    }
    
    func fetchData() {
        loadSavedData()
    }
    
    private func loadSavedData() {
        if fetchedResultsController == nil {
            let request = VocaSection.createFetchRequest()
            let sort = NSSortDescriptor(key: "date", ascending: true)
            request.sortDescriptors = [sort]
            fetchedResultsController =
                NSFetchedResultsController(fetchRequest: request,
                                           managedObjectContext: coreDataStack.managedContext,
                                           sectionNameKeyPath: nil,
                                           cacheName: nil)
            fetchedResultsController.delegate = self
        }
        if !currentSearchText.isEmpty {
            predicate = NSPredicate(format: "name CONTAINS[c] %@", currentSearchText)
        }
        fetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            try fetchedResultsController.performFetch()
            //            updateSnapshot()
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
            coreDataStack.managedContext.delete(section)
        }
        coreDataStack.saveContext()
    }
    
    func toggleFavorite(at indexPath: IndexPath) {
        print(indexPath)
        guard let section = fetchedResultsController.fetchedObjects?[indexPath.section] else { return }
        let voca = section.vocaArray[indexPath.row - 1]
        voca.isFavorite.toggle()
        coreDataStack.saveContext()
        vocaUpdatePublisher.send((indexPath, voca))
    }
    
    func addFolder(title: String) {
        let s = VocaSection(context: coreDataStack.managedContext)
        s.date = Date()
        s.title = title
        s.id = UUID()
        coreDataStack.saveContext()
    }
    
    func addVocas(_ vocas: [(question: String, answer: String)], to folder: String) {
        let section = fetchedResultsController.fetchedObjects?.first(where: { section -> Bool in
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
    }
    
}

extension VocaListViewModel: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        print(#function)
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        guard let vocaSections = fetchedResultsController.fetchedObjects else { return }
        let sections = vocaSections.map { Section.folder(count: $0.vocas.count, title: $0.title) }
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        snapshotPublisher.send(snapshot)
        
        for (index, section) in vocaSections.enumerated() {
            var sectionSnapshot = SectionSnapshot()
            let header = VocaItem.parent(section)
            sectionSnapshot.append([header])
            sectionSnapshot.append(
                section.vocaArray.map {  VocaItem.child($0) },
                to: header
            )
            sectionSnapshot.expand([header])
            sectionSnapshotPublisher.send((sectionSnapshot, sections[index]))
        }
    }
    
}

extension VocaListViewModel: VocaAddDelegate {
    func didAdd(_ vocas: [(String, String)], to folder: String) {
        addVocas(vocas, to: folder)
    }
}
