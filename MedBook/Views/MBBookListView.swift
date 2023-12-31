//
//  MBBookListView.swift
//  MedBook
//
//  Created by Shlok Tyagi on 29/12/23.
//

import UIKit
import Combine

class MBBookListView: UIView {
    
    private let viewModel = MBBookListViewModel()
    
    private var cancellable : AnyCancellable?
    
    @IBOutlet private weak var searchTextField: UITextField!
    @Published var searchText: String = ""
    
    @IBOutlet private weak var titleSortButton: UIButton!
    @IBOutlet private weak var averageSortButton: UIButton!
    @IBOutlet private weak var hitsSortButton: UIButton!
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    public func setupView(){
        
        ///Items initiialy sorted by title
        viewModel.currentSortCategory = .title
        titleSortButton.isSelected = true
        averageSortButton.isSelected = false
        hitsSortButton.isSelected = false
        
        activityIndicator.hidesWhenStopped = true
        
        titleSortButton.addTarget(self,
                                  action: #selector(sortByTitle),
                                  for: .touchUpInside)
        averageSortButton.addTarget(self,
                                    action: #selector(sortByAverage),
                                    for: .touchUpInside)
        hitsSortButton.addTarget(self,
                                 action: #selector(sortByHits),
                                 for: .touchUpInside)
        
        searchTextField.delegate = self
        searchTextField.addLeadingPaddingToTextField()
        
        tableView.delegate = viewModel
        tableView.prefetchDataSource = viewModel
        tableView.dataSource = viewModel
        tableView.separatorStyle = .none
        
        viewModel.delegate = self
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
        
        setupTextFieldListener()
    }
    
    /// Catch textDidChangeNotification
    private func setupTextFieldListener(){
        
        cancellable = searchTextField.textPublisher
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)///publishes events only after time duration elapses
            .sink { [weak self] searchText in

                /// Initiates fetch when 3 or more characters entered
                if (searchText.trimmingCharacters(in: .whitespacesAndNewlines).count >= 3)
                    && (searchText != self?.viewModel.searchText) {
                    
                    self?.viewModel.searchText = searchText
                    self?.viewModel.fetchBooks(withTitle: searchText)
                    DispatchQueue.main.async {
                        self?.activityIndicator.startAnimating()
                    }
                    
                }else{
                    self?.viewModel.searchText = ""
                    self?.viewModel.fetchBooks(withTitle: "")
                }
            }
        
    }
    
    @objc private func sortByTitle(){
        titleSortButton.isSelected = true
        averageSortButton.isSelected = false
        hitsSortButton.isSelected = false
        viewModel.sortBy(category: .title)
    }
    
    @objc private func sortByAverage(){
        titleSortButton.isSelected = false
        averageSortButton.isSelected = true
        hitsSortButton.isSelected = false
        viewModel.sortBy(category: .average)
    }
    
    @objc private func sortByHits(){
        titleSortButton.isSelected = false
        averageSortButton.isSelected = false
        hitsSortButton.isSelected = true
        viewModel.sortBy(category: .hits)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
  
}

// MARK: UITextFieldDelegate Methods

extension MBBookListView: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }

}

// MARK: MBBookListViewModelDelegate Methods

extension MBBookListView: MBBookListViewModelDelegate{
    
    func reloadBooks() {
        activityIndicator.stopAnimating()
        tableView.reloadData()
//        tableView.setContentOffset(.zero, animated: true)
    }
        
}
