//
//  MBBookListTableViewCellViewModel.swift
//  MedBook
//
//  Created by Shlok Tyagi on 29/12/23.
//

import UIKit

class MBBookListTableViewCellViewModel{
    
    public let title:String
    public let author: String
    public let ratingAverage: Double
    public let ratingCount: Int
    private let imageID: Int
    
    init(title: String,
         author: String,
         ratingAverage: Double,
         ratingCount: Int,
         imageID: Int) {
        self.title = title
        self.author = author
        self.ratingAverage = ratingAverage
        self.ratingCount = ratingCount
        self.imageID = imageID
    }
    
    public func fetchImage(completion: @escaping(Result<Data,Error>) -> Void){
        
        let imageURLString = String(format: "https://covers.openlibrary.org/b/id/%d-M.jpg", imageID)
        
        guard let url = URL(string: imageURLString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        /// Pass URL to MBImageLoader
        MBImageLoader.shared.downloadImage(url,
                                           completion: completion)
    }
    
}
