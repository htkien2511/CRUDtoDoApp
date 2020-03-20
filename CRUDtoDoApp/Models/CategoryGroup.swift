//
//  CatergoryGroup.swift
//  CRUDtoDoApp
//
//  Created by Hoang Trong Kien on 3/20/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit
import CoreData

class CategoryGroup {
    var categories: [Category] = []
    
    func fetch() -> [NSManagedObject] {
        var phieuMuon: [NSManagedObject] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return phieuMuon
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PhieuMuon")
        
        do {
            phieuMuon = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return phieuMuon
    }
    
    func save() {
        
    }
}
