//
//  ExamListViewModel.swift
//  Voca
//
//  Created by 강병민 on 2021/01/20.
//

import Foundation
import UIKit
import Combine
import CoreData

enum ExamSection: Int, CaseIterable {
    case favorite
    case folder
}

enum CategorizedSection: Hashable {
    case favorite(VocaSection)
    case folder(VocaSection)
}

class ExamListViewModel: NSObject {
    
    let coreDataStack: CoreDataStack
    var vocaSectionFetchedController: NSFetchedResultsController<VocaSection>!
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<ExamSection, CategorizedSection>
    let snapshotPublisher = PassthroughSubject<Snapshot, Never>()
    
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
        }
        do {
            try vocaSectionFetchedController.performFetch()
            updateSnapshot()
        } catch {
            print("Fetch failed")
        }
    }
    
    private func updateSnapshot() {
        guard let vocaSections = vocaSectionFetchedController.fetchedObjects else { return }
        let favoriteSections = vocaSections[0...1].map { CategorizedSection.favorite($0) }
        let folderSections = vocaSections.map { CategorizedSection.folder($0) }
        var snapshot = Snapshot()
        snapshot.appendSections([.favorite, .folder])
        snapshot.appendItems(favoriteSections, toSection: .favorite)
        snapshot.appendItems(folderSections, toSection: .folder)
        snapshotPublisher.send(snapshot)
    }

}

extension ExamListViewModel: ExamDelegate {
    
    func save() {
        coreDataStack.saveContext()
    }
    
}
