//
//  EndPoint.swift
//  CakeItApp
//
//  Created by DEEPTHI SANTHA on 2/2/22.
//

import Foundation

protocol Endpoint {
    var scheme: String {get} // HTTP or HTTPS
    var baseURL: String {get}
    var path: String {get}
    var method: String {get}
}
