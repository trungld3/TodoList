//
//  Category.swift
//  TodoList
//
//  Created by TrungLD on 4/26/20.
//  Copyright © 2020 TrungLD. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
   
    
}
