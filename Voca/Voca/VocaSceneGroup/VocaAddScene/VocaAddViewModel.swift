//
//  VocaAddViewModel.swift
//  Voca
//
//  Created by 강병민 on 2021/01/28.
//

import Foundation

protocol VocaAddDelegate: class {
    func didAdd(_ voca: (answer: String, question: String), to folder: String)
}

class VocaAddViewModel {
    var folders: [VocaSection] = []
    var pickedFolderIndex = 0
    var cellViewModels = [VocaAddCellViewModel()]
    weak var delegate: VocaAddDelegate?
    var isValid: Bool {
        cellViewModels.allSatisfy { $0.isValid == true }
    }
    var invalidIndexPath: IndexPath? {
        if let index = cellViewModels.firstIndex(where: { $0.isValid == false }) {
            return IndexPath(row: index, section: 0)
        } else {
            return nil
        }
    }
    
    func appendCellViewModel() {
        cellViewModels.append(VocaAddCellViewModel())
    }
    
    func removeCellViewModel(at index: Int) {
        cellViewModels.remove(at: index)
    }
    
    func didPressAddVocas() {
        let firstVoca = cellViewModels.first.map { vm -> (String, String) in
            (vm.questionText, vm.answerText)
        }
        delegate?.didAdd(firstVoca!, to: folders[pickedFolderIndex].title)
    }
}
