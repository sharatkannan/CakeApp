//
//  Cake.swift
//  CakeItApp
//
//  Created by David McCallum on 21/01/2021.
//

import Foundation
import UIKit

class Cake: Hashable, Codable {
    let title: String
    let desc: String
    var image: String
    var Orginalimage: UIImage = UIImage(named:"CakeDummyImage") ?? UIImage()
    
    var identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: Cake, rhs: Cake) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private enum CodingKeys: String, CodingKey {
            case title, desc,image
    }
}

