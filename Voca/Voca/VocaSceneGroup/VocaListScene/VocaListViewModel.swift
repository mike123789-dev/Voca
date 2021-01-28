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

class VocaListViewModel: NSObject {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<VocaSection, VocaItem>
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<VocaItem>

    var container = NSPersistentContainer(name: "Voca")
    var currentSearchText = ""
    var predicate: NSPredicate?
    var fetchedResultsController: NSFetchedResultsController<VocaSection>!

    let snapshotPublisher = PassthroughSubject<Snapshot, Never>()
    let sectionSnapshotPublisher = PassthroughSubject<(SectionSnapshot, VocaSection), Never>()
    
    func setup() {
        setupCoreData()
        loadSavedData()
//        fetch()
    }
    
    private func fetch() {
        let sections = TestData.sections
        sections.forEach { section in
            let s = VocaSection(context: container.viewContext)
            s.date = Date()
            s.title = section.title
            s.id = UUID()
            section.vocas.forEach { voca in
                let v = Voca(context: container.viewContext)
                v.answer = voca.answer
                v.question = voca.question
                v.correctCount = 0
                v.wrongCount = 0
                v.isFavorite = false
                v.date = Date()
                v.id = UUID()
                s.addToVocas(v)
            }
        }
        loadSavedData()
    }

    private func setupCoreData() {
        container.loadPersistentStores { _, _ in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
    }

    private func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }

    private func loadSavedData() {
        if fetchedResultsController == nil {
            let request = VocaSection.createFetchRequest()
            let sort = NSSortDescriptor(key: "date", ascending: true)
            request.sortDescriptors = [sort]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: container.viewContext,
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
            print("updateSnapshot1")
            updateSnapshot()
        } catch {
            print("Fetch failed")
        }
    }

    private func updateSnapshot() {
        guard let sections = fetchedResultsController.fetchedObjects else { return }
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        snapshotPublisher.send(snapshot)
        
        for section in sections {
            var sectionSnapshot = SectionSnapshot()
            let header = VocaItem.parent(section)
            sectionSnapshot.append([header])
            sectionSnapshot.append(
                section.vocaArray.map {
                    VocaItem.child($0)
                },
                to: header
            )
            sectionSnapshot.expand([header])
            sectionSnapshotPublisher.send((sectionSnapshot, section))
        }
    }
    
}
extension VocaListViewModel {
    func delete(_ item: VocaItem) {
        switch item {
        case .child(let voca):
            container.viewContext.delete(voca)
        case .parent(let section):
            container.viewContext.delete(section)
        }
        saveContext()
    }
    
    func addFolder(title: String) {
        let s = VocaSection(context: container.viewContext)
        s.date = Date()
        s.title = title
        s.id = UUID()
        saveContext()
        updateSnapshot()
    }
    
    func addVoca(_ voca: (String, String), to folder: String) {
    }
    
}

extension VocaListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        print("updateSnapshot2")
//        updateSnapshot()
    }
}
