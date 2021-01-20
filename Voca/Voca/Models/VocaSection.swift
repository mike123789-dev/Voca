//
//  VocaSection.swift
//  VocaApp
//
//  Created by 강병민 on 2020/10/21.
//
import Foundation

class VocaSection: Hashable {

    let id = UUID()
    let title: String
    var vocaBrains: [VocaBrain] = []
    var vocas: [Voca] {
        vocaBrains.map{$0.voca}
    }
    var vocaCounts: Int{
        vocaBrains.count
    }
    
    init(title : String) {
        self.title = title
    }

    func add(voca : Voca){
        self.vocaBrains.append(VocaBrain(voca: voca))
    }
    
    func addMutliple(vocas : [Voca]){
        self.vocaBrains.append(contentsOf: vocas.map{VocaBrain(voca: $0)})
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: VocaSection, rhs: VocaSection) -> Bool {
        lhs.id == rhs.id
    }
    
}
