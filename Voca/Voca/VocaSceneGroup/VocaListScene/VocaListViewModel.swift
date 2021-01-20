//
//  VocaListViewModel.swift
//  Voca
//
//  Created by 강병민 on 2021/01/20.
//

import Foundation
import UIKit
import Combine

enum VocaItem: Hashable {
    case parent(VocaSection)
    case child(Voca)
}

class VocaListViewModel {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<VocaSection, VocaItem>
    typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<VocaItem>
    
    let snapshotPublisher = PassthroughSubject<Snapshot, Never>()
    let sectionSnapshotPublisher = PassthroughSubject<(SectionSnapshot, VocaSection), Never>()
    
    func fetch() {
        let sections = TestData.sections
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        snapshotPublisher.send(snapshot)
        
        for section in sections {
            var sectionSnapshot = SectionSnapshot()
            let header = VocaItem.parent(section)
            sectionSnapshot.append([header])
            sectionSnapshot.append(
                section.vocas.map {
                    VocaItem.child($0)
                },
                to: header
            )
            sectionSnapshotPublisher.send((sectionSnapshot, section))
        }
        
    }
    
}
