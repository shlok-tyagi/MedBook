//
//  MBImageLoader.swift
//  MedBook
//
//  Created by Shlok Tyagi on 29/12/23.
//

import Foundation

class MBImageLoader{
    
    static let shared = MBImageLoader()

    private var imageDataCache = NSCache<NSString,NSData>()
    
    private init(){
    }
    
    
    /// Get image data with URL
    /// - Parameters:
    ///   - url: Image URL
    ///   - completion: Callback
    public func downloadImage(_ url: URL,
                              completion: @escaping(Result<Data,Error>) -> Void){
        
        ///Fetch from cache if already exists
        let key = NSString(string: url.absoluteString)
        if let data = self.imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            let value = data as NSData
            self.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        
        task.resume()
        
    }
    
    
}
