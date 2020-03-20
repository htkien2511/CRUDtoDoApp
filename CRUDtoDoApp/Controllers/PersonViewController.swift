//
//  PersonViewController.swift
//  CRUDtoDoApp
//
//  Created by Hoang Trong Kien on 3/4/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit
import CoreData

class PersonViewController: UIViewController {
    
    var people: [NSManagedObject] = []
    var nguoiMuon = ""

    @IBOutlet weak var txtNguoiMuon: UILabel!
    @IBOutlet weak var txtTuoi: UILabel!
    
    
    @IBOutlet weak var txtTuoiMoi: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtNguoiMuon.text = nguoiMuon
        fetchData()
    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NguoiMuon")

        do {
            people = try managedContext.fetch(fetchRequest)
            for item in people {
                if item.value(forKeyPath: "nguoiMuon") as? String == nguoiMuon {
                    txtNguoiMuon.text = item.value(forKeyPath: "nguoiMuon") as? String
                    let tuoi = item.value(forKeyPath: "tuoi") as? Int16
                    txtTuoi.text = String(tuoi!)
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    @IBAction func savePerson(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "NguoiMuon", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        guard let tuoi = txtTuoiMoi.text else {
            return
        }
        
        person.setValue(nguoiMuon, forKey: "nguoiMuon")
        let tuoiInt = Int(tuoi)
        person.setValue(tuoiInt!, forKey: "tuoi")
        
        
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        txtNguoiMuon.text = nguoiMuon
        txtTuoi.text = tuoi
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
