//
//  CategoryDetailViewController.swift
//  CRUDtoDoApp
//
//  Created by Hoang Trong Kien on 3/1/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit
import CoreData

class CategoryDetailViewController: UIViewController {

    var categoryDetails: [NSManagedObject] = []
    
    @IBOutlet weak var txtSoPhieu: UITextField!
    @IBOutlet weak var txtMaSach: UITextField!
    @IBOutlet weak var txtNgayTra: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func maSachAction(_ sender: Any) {
    }
    
    @IBAction func save(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ChiTietPhieuMuon", in: managedContext)!
        let categoryDetail = NSManagedObject(entity: entity, insertInto: managedContext)
        
        guard let soPhieu = txtSoPhieu.text, let maSach = txtMaSach.text, let ngayTra = txtNgayTra.text else {
            return
        }
        
        categoryDetail.setValue(soPhieu, forKeyPath: "soPhieu")
        categoryDetail.setValue(maSach, forKeyPath: "maSach")
        categoryDetail.setValue(ngayTra, forKeyPath: "ngayTra")
        
        do {
            try managedContext.save()
            categoryDetails.append(categoryDetail)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
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
