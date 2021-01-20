//
//  TestData.swift
//  Voca
//
//  Created by 강병민 on 2021/01/20.
//

import Foundation

struct TestData {
        
    static var section1: VocaSection {
        let section: VocaSection = VocaSection(title: "수능")
        section.add(voca: Voca(question: "apple", answer: "사과"))
        section.add(voca: Voca(question: "tree", answer: "나무"))
        section.add(voca: Voca(question: "coffee", answer: "커피"))
        section.add(voca: Voca(question: "paradise", answer: "천국"))
        section.add(voca: Voca(question: "hell", answer: "지옥"))
        return section
    }
    
    static var section2: VocaSection {
        let section: VocaSection = VocaSection(title: "토익")
        section.add(voca: Voca(question: "milk", answer: "우유"))
        section.add(voca: Voca(question: "grape", answer: "포도"))
        return section
    }
    
    static let sections: [VocaSection]
        = [section1, section2]
    
}
