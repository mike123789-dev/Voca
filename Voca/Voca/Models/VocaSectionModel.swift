//
//  VocaSection.swift
//  VocaApp
//
//  Created by 강병민 on 2020/10/21.
//
import Foundation

class VocaSectionModel: Hashable {

    let id = UUID()
    let title: String
    var vocaBrains: [VocaBrain] = []
    var vocas: [VocaModel] {
        vocaBrains.map { $0.voca }
    }
    var vocaCounts: Int {
        vocaBrains.count
    }
    
    init(title: String) {
        self.title = title
    }

    func add(voca: VocaModel) {
        self.vocaBrains.append(VocaBrain(voca: voca))
    }
    
    func addMutliple(vocas: [VocaModel]) {
        self.vocaBrains.append(contentsOf: vocas.map { VocaBrain(voca: $0) })
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: VocaSectionModel, rhs: VocaSectionModel) -> Bool {
        lhs.id == rhs.id
    }
    
}
