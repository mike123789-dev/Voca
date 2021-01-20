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
        section.add(voca: Voca(question: "cup", answer: "컵"))
        section.add(voca: Voca(question: "airplane", answer: "비행기"))
        section.add(voca: Voca(question: "boat", answer: "배"))
        section.add(voca: Voca(question: "happy", answer: "행복한"))
        section.add(voca: Voca(question: "sad", answer: "슬픈"))


        return section
    }
    
    static var section2: VocaSection {
        let section: VocaSection = VocaSection(title: "토익")
        section.add(voca: Voca(question: "milk", answer: "우유"))
        section.add(voca: Voca(question: "grape", answer: "포도"))
        section.add(voca: Voca(question: "water", answer: "물"))
        section.add(voca: Voca(question: "shrimp", answer: "새우"))
        section.add(voca: Voca(question: "salmon", answer: "연어"))
        return section
    }
    
    static var section3: VocaSection {
        let section: VocaSection = VocaSection(title: "텝스")
        section.add(voca: Voca(question: "section", answer: "구역"))
        section.add(voca: Voca(question: "beer", answer: "맥주"))
        section.add(voca: Voca(question: "bear", answer: "곰"))
        section.add(voca: Voca(question: "bear", answer: "버티다"))
        section.add(voca: Voca(question: "swift", answer: "빠른"))

        return section
    }
    
    static let sections: [VocaSection]
        = [section1, section2, section3]
    
}
