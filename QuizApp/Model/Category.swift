//
//  Category.swift
//  QuizApp
//
//  Created by Илья on 4/16/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Category{
    let name: String
    let id: Int
}

extension Category{
    init?(json: JSON){
        self.name = json["name"].stringValue
        self.id = json["id"].intValue
    }
}
