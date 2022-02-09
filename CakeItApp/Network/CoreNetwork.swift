//
//  CoreNetwork.swift
//  CakeItApp
//
//  Created by DEEPTHI SANTHA on 2/2/22.
//

import Foundation

class CoreNetwork {
    
    class func request<T: Codable> (endpoint: Endpoint, completion: @escaping (Result<[T], Error>) -> ()) {
            
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.baseURL
        components.path = endpoint.path
            
        guard let url = components.url else {
            print("*** NOT ABLE TO CREATE URL ***")
            return
        }
            
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) {data,response,error in
                
            guard error == nil else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "*** Unknown Network error ****")
                return
            }
                
            guard response != nil, let data = data else {
                let error = NSError(domain: "Network", code: 400, userInfo: [NSLocalizedDescriptionKey: "Response not available"])
                completion(.failure(error))
                return
            }
                
            DispatchQueue.main.async {
                if let responseObject = try? JSONDecoder().decode([T].self, from: data) {
                    completion(.success(responseObject))
                } else {
                    let error = NSError(domain: "Network", code: 200, userInfo: [NSLocalizedDescriptionKey: "Faliled to Decode the JSON"])
                    completion(.failure(error))
                }
            }
        }
            dataTask.resume()
        }
}


















