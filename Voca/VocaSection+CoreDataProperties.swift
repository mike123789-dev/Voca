//
//  VocaSection+CoreDataProperties.swift
//  Voca
//
//  Created by 강병민 on 2021/01/21.
//
//

import Foundation
import CoreData

extension VocaSection {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<VocaSection> {
        return NSFetchRequest<VocaSection>(entityName: "VocaSection")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var vocas: NSSet
    
    public var vocaArray: [Voca] {
        let set = vocas as? Set<Voca> ?? []
        return set.sorted {
            $0.date < $1.date
        }
    }
}

// MARK: Generated accessors for vocas
extension VocaSection {

    @objc(addVocasObject:)
    @NSManaged public func addToVocas(_ value: Voca)

    @objc(removeVocasObject:)
    @NSManaged public func removeFromVocas(_ value: Voca)

    @objc(addVocas:)
    @NSManaged public func addToVocas(_ values: NSSet)

    @objc(removeVocas:)
    @NSManaged public func removeFromVocas(_ values: NSSet)

}

extension VocaSection: Identifiable {

}
