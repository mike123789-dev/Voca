//
//  Voca+CoreDataProperties.swift
//  Voca
//
//  Created by 강병민 on 2021/01/21.
//
//

import Foundation
import CoreData

extension Voca {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Voca> {
        return NSFetchRequest<Voca>(entityName: "Voca")
    }

    @NSManaged public var id: UUID
    @NSManaged public var question: String
    @NSManaged public var answer: String
    @NSManaged public var date: Date
    @NSManaged public var isFavorite: Bool
    @NSManaged public var correctCount: Int32
    @NSManaged public var wrongCount: Int32
    @NSManaged public var section: VocaSection

    var totalCount: Int {
        Int(correctCount + wrongCount)
    }
    var correctAnswerRate: Double {
        Double(correctCount)/Double(totalCount)
    }
        
    func answerWrong() {
        wrongCount += 1
    }
    func answerCorrect() {
        correctCount += 1
    }
    
}

extension Voca: Identifiable {

}
