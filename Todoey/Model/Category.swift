//
//  Category.swift
//  Todoey
//
//  Created by Tommy Krohn on 26.06.2018.
//  Copyright © 2018 Tommy Krohn. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
    
}
