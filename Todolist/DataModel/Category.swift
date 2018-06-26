//
//  Category.swift
//  Todolist
//
//  Created by Ka ka Tam on 26/06/2018.
//  Copyright © 2018 Ka ka Tam. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
