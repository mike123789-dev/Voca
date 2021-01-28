//
//  TestData.swift
//  Voca
//
//  Created by 강병민 on 2021/01/20.
//

import Foundation

struct TestData {

    static var section2: VocaSectionModel {
        let section: VocaSectionModel = VocaSectionModel(title: "토익")
        section.add(voca: AddVocaModel(question: "milk", answer: "우유"))
        section.add(voca: AddVocaModel(question: "grape", answer: "포도"))
        section.add(voca: AddVocaModel(question: "water", answer: "물"))
        section.add(voca: AddVocaModel(question: "shrimp", answer: "새우"))
        section.add(voca: AddVocaModel(question: "salmon", answer: "연어"))
        return section
    }

    static var section3: VocaSectionModel {
        let section: VocaSectionModel = VocaSectionModel(title: "텝스")
        section.add(voca: AddVocaModel(question: "section", answer: "구역"))
        section.add(voca: AddVocaModel(question: "beer", answer: "맥주"))
        section.add(voca: AddVocaModel(question: "bear", answer: "곰"))
        section.add(voca: AddVocaModel(question: "bear", answer: "버티다"))
        section.add(voca: AddVocaModel(question: "swift", answer: "빠른"))

        return section
    }

    static let sections: [VocaSectionModel]
        = [section2, section3]

}
