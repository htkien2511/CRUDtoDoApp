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
    var soPhieu = ""
    var nguoiMuon = ""
    
    
    @IBOutlet weak var txtSoPhieu: UILabel!
    @IBOutlet weak var txtMaSach: UILabel!
    @IBOutlet weak var txtNgayTra: UILabel!
    @IBOutlet weak var txtNguoiMuon: UILabel!
    
    @IBOutlet weak var txtMaSachMoi: UITextField!
    @IBOutlet weak var txtNgayTraMoi: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chi tiết phiếu mượn"
        fetchData()
        txtSoPhieu.text = soPhieu
        txtNguoiMuon.text = nguoiMuon
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        if vc is BookViewController {
            let bookVC = vc as! BookViewController
            bookVC.maSach = txtMaSach.text!
        } else if vc is PersonViewController {
            let peopleVC = vc as! PersonViewController
            peopleVC.nguoiMuon = txtNguoiMuon.text!
        }
    }
    
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ChiTietPhieuMuon")

        do {
            categoryDetails = try managedContext.fetch(fetchRequest)
            for item in categoryDetails {
                if item.value(forKeyPath: "soPhieu") as! String == soPhieu {
                    txtMaSach.text = item.value(forKeyPath: "maSach") as? String
                    txtNgayTra.text = item.value(forKeyPath: "ngayTra") as? String
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
        //presentingViewController?.dismiss(animated: true, completion: nil)
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
        
        guard let maSach = txtMaSachMoi.text, let ngayTra = txtNgayTraMoi.text else {
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
        
        txtMaSach.text = maSach
        txtNgayTra.text = ngayTra
        
    }
    

}
