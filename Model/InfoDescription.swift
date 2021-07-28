//
//  UserData.swift
//  just camping
//
//  Created by 則佑林 on 2021/1/5.
//

import Foundation
import CoreData

class InfoDescription: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var rating: String?
    @NSManaged var seq: Double
    override func awakeFromInsert() {
        self.seq = 0
    }
}
