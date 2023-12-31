//
//  MBService.swift
//  MedBook
//
//  Created by Shlok Tyagi on 29/12/23.
//

import Foundation

class MBService{
    
    static let shared = MBService()
    
    private init(){
    }
    
    enum MBServiceError: Error{
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Executes the request using URLSession
    /// - Parameters:
    ///   - request: MBRequest
    ///   - type: expecting Type
    ///   - completion: Callback
    public func execute<T: Codable>(_ request: MBRequest,
                                    expecting type: T.Type,
                                    completion: @escaping(Result<T,Error>) -> Void){
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(MBServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            
            guard let data = data, error == nil else {
                completion(.failure(error ?? MBServiceError.failedToGetData))
                return
            }
            
            //Decode response
            do{
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            }catch{
                completion(.failure(error))
            }
            
        }
        
        task.resume()
        
    }
    
    /// Creates URLRequest from MBRequest
    /// - Parameter mbRequest: MBRequest
    /// - Returns: URLRequest
    private func request(from mbRequest: MBRequest) -> URLRequest?{
        guard let url = mbRequest.url else { return nil}
        var request = URLRequest(url: url)
        request.httpMethod = mbRequest.httpMethod
        return request
    }
    
    
    
}
