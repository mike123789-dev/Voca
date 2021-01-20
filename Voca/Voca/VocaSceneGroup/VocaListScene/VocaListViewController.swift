//
//  VocaListViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/20.
//

import UIKit

class VocaListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = VocaListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapEditButton(_ sender: Any) {
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
    }
    
}
