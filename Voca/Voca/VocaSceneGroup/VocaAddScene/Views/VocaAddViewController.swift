//
//  VocaAddViewController.swift
//  Voca
//
//  Created by 강병민 on 2021/01/27.
//

import UIKit

class VocaAddViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = VocaAddViewModel()
    var cellViewModels: [VocaAddCellViewModel] {
        viewModel.cellViewModels
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        setupKeyboard()
    }
    
    @IBAction func didPressAddVocas(_ sender: Any) {
        if viewModel.isValid {
            viewModel.didPressAddVocas()
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "추가하지 못했습니다",
                                          message: "비어있는 텍스트필드가 없는지 확인해주세요",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인",
                                         style: .default) {[weak self] _ in
                guard let self = self else { return }
                self.tableView.scrollToRow(at: self.viewModel.invalidIndexPath!,
                                           at: .middle,
                                           animated: true)
            }
            alert.addAction(okAction)
            present(alert, animated: true)
        }
        
    }
    
    @IBAction func didPressAddNewCell(_ sender: Any) {
        viewModel.appendCellViewModel()
        tableView.reloadData()
    }
    
    @IBAction func didTapCameraButton(_ sender: Any) {
    }
}
extension VocaAddViewController {
    private func setupKeyboard() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillShow(notification:)),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)
        NotificationCenter.default
            .addObserver(self,
                    selector: #selector(keyboardWillHide(notification:)),
                    name: UIResponder.keyboardWillHideNotification,
                    object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    
}

extension VocaAddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddVoca") as? VocaAddTableViewCell
        cell?.configure(with: cellViewModels[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellViewModels.count
    }
}

extension VocaAddViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeCellViewModel(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
}

extension VocaAddViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.folders[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(viewModel.folders[row].title)
        viewModel.pickedFolderIndex = row
    }
}

extension VocaAddViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.folders.count
    }
}
