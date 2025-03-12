//
//  animals.swift
//  shozoo
//
//  Created by ichinose-PC on 2025/02/21.
//

import Foundation
import RealmSwift

class animals: Object
{
    @objc dynamic var name = ""
    @objc dynamic var count = 0
    @objc dynamic var date = Date()
}
