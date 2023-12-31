//
//  MBBookListViewModel.swift
//  MedBook
//
//  Created by Shlok Tyagi on 29/12/23.
//

import UIKit

enum SortCategory{
    case title
    case average
    case hits
}

protocol MBBookListViewModelDelegate : AnyObject{
    func reloadBooks()
}

class MBBookListViewModel: NSObject{
    
    private let fetchLimit = 20
    
    public var searchText: String = ""
    
    private var isLoadingMoreBooks = false /// Tracks if more books are being fetched
    
    public var delegate: MBBookListViewModelDelegate?
    
    public var currentSortCategory: SortCategory?
    
    private var books: [MBBook] = []
    
    private var cellViewModels: [MBBookListTableViewCellViewModel] = []
    
    /// Initial fetch for books
    public func fetchBooks(withTitle title:String){
        
        /// New searchText , reset everything
        books.removeAll()
        cellViewModels.removeAll()
        DispatchQueue.main.async {
            self.delegate?.reloadBooks()
        }
        
        if title == ""{
            return
        }
        
        let queryParams = MBQueryParams(title: title,
                                        limit: fetchLimit,
                                        offset: 0).queryItems
        let request = MBRequest(baseURL: .openlibrary,
                                queryParameters: queryParams)
        
        MBService.shared.execute(request,
                                 expecting: MBBookResult.self) {[weak self] result in
            
            guard let strongSelf = self else{
                return
            }
            
            switch result{
                
            case .success(let bookResult):
                let books = bookResult.books
                strongSelf.books = books
                strongSelf.cellViewModels = strongSelf.createViewModels(for: strongSelf.books)
                DispatchQueue.main.async {
                    strongSelf.sortBy(category: strongSelf.currentSortCategory!)
                }
                
            case .failure(let failure):
                print(String(describing: failure))
            }
            
        }
    }
    
    /// Subsequent fetch for books with the same searchText
    private func fetchMoreBooks(){
        
        guard !isLoadingMoreBooks else {
            return
        }
        
        isLoadingMoreBooks = true
        
        let queryParams = MBQueryParams(title: self.searchText,
                                        limit: fetchLimit,
                                        offset: books.count).queryItems
        let request = MBRequest(baseURL: .openlibrary,
                                queryParameters: queryParams)
        
        MBService.shared.execute(request,
                                 expecting: MBBookResult.self) {[weak self] result in
            
            guard let strongSelf = self else{
                return
            }
            
            switch result{
            case .success(let bookResult):
                let books = bookResult.books
                strongSelf.books.append(contentsOf: books)
                strongSelf.cellViewModels = strongSelf.createViewModels(for: strongSelf.books)
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreBooks = false
                    strongSelf.sortBy(category: strongSelf.currentSortCategory!)
                }
            case .failure(let failure):
                print(String(describing: failure))
                strongSelf.isLoadingMoreBooks = false
            }
            
        }
    }
    
    /// Create MBBookListTableViewCellViewModel from MBBook
    /// - Parameter books: Array of MBBook
    /// - Returns: Array of MBBookListTableViewCellViewModel
    private func createViewModels(for books: [MBBook]) -> [MBBookListTableViewCellViewModel]{
        
        var viewModels: [MBBookListTableViewCellViewModel] = []

        if !books.isEmpty{
            for book in books {
                
                let authorString = book.authorNames?.joined(separator: ",")
                
                let viewModel = MBBookListTableViewCellViewModel(title: book.title,
                                                                 author: authorString ?? "",
                                                                 ratingAverage: book.ratingsAverage ?? 0,
                                                                 ratingCount: book.ratingsCount ?? 0,
                                                                 imageID: book.imageID ?? 0)
                
                viewModels.append(viewModel)
            }
        }
        
        return viewModels
    }
    
    public func sortBy(category: SortCategory){
        
        switch category{
        case .title:
            currentSortCategory = .title
        case .average:
            currentSortCategory = .average
        case .hits:
            currentSortCategory = .hits
        }
        
        /// Reload tableView only if more books are not being fetched
        if !isLoadingMoreBooks{
            switch category{
            case .title:
                cellViewModels = cellViewModels.sorted { lhs, rhs in
                    lhs.title < rhs.title
                }
            case .average:
                cellViewModels = cellViewModels.sorted { lhs, rhs in
                    lhs.ratingAverage > rhs.ratingAverage
                }
            case .hits:
                cellViewModels = cellViewModels.sorted { lhs, rhs in
                    lhs.ratingCount > rhs.ratingCount
                }
            }
            
            DispatchQueue.main.async {
                self.delegate?.reloadBooks()
            }
        }
        
    }
    
}

// MARK: UITableView Delegate, DataSource & DataSourcePrefetc methods

extension MBBookListViewModel: UITableViewDelegate,UITableViewDataSource,UITableViewDataSourcePrefetching{
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MBBookListTableViewCell.cellIdentifier,
                                                       for: indexPath) as? MBBookListTableViewCell else{
            fatalError("Unsupported cell")
        }
        
        cell.configure(with: cellViewModels[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
   
    func tableView(_ tableView: UITableView,
                   prefetchRowsAt indexPaths: [IndexPath]) {
        
        guard !isLoadingMoreBooks else {
            return
        }
        
        /// Initiate fetching more books
        for index in indexPaths {
            if index.row >= books.count - 2 {
                fetchMoreBooks()
            }
        }
        
    }
    
    
}
