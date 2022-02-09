//
//  CakeListEndpoint.swift
//  CakeItApp
//
//  Created by Sarath VS on 2/2/22.
//

import Foundation

struct CakeListEndpoint : Endpoint {
    
    var scheme: String { NetwrokConfiguration.Base.scheme }
    
    var baseURL: String { NetwrokConfiguration.Base.URL }
    
    var path: String { NetwrokConfiguration.Path.Cake.list}
    
    var method: String {"GET"}
    
   static func getCakeList(completion: @escaping ([Cake]?, String?) -> ()) {
        let cakeEndpoint = CakeListEndpoint()
        CoreNetwork.request(endpoint: cakeEndpoint) { (result: Result<[Cake], Error>) in
            switch result {
                case .success(let response):
                    completion(response, nil)
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                    print(error)
            }
        }
    }
}

