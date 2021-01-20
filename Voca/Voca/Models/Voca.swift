//
//  Voca.swift
//  VocaApp
//
//  Created by 강병민 on 2020/10/19.
//

import Foundation

struct Voca: Hashable {
    let id = UUID()
    let question: String
    let answer: String
}
