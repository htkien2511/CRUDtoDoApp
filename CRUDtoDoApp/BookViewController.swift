//
//  BookViewController.swift
//  CRUDtoDoApp
//
//  Created by Hoang Trong Kien on 3/2/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit
import CoreData

class BookViewController: UIViewController {
    
    var books: [NSManagedObject] = []
    var maSach = ""

    @IBOutlet weak var maSachLabel: UILabel!
    @IBOutlet weak var tenSach: UILabel!
    @IBOutlet weak var maTacGia: UILabel!
    @IBOutlet weak var loaiSach: UILabel!
    @IBOutlet weak var namXuatBan: UILabel!
    
    @IBOutlet weak var txtTenSachMoi: UITextField!
    @IBOutlet weak var txtMaTacGiaMoi: UITextField!
    @IBOutlet weak var txtLoaiSachMoi: UITextField!
    @IBOutlet weak var txtNamXuatBanMoi: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maSachLabel.text = maSach
        fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let authorVC = segue.destination as! AuthorViewController
        authorVC.maTG = maTacGia.text!
    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContextObject = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Sach")
        do {
            try books = managedContextObject.fetch(fetchRequest)
            for item in books {
                if item.value(forKeyPath: "maSach") as! String == maSach {
                    tenSach.text = item.value(forKeyPath: "tenSach") as? String
                    maTacGia.text = item.value(forKeyPath: "maTacGia") as? String
                    loaiSach.text = item.value(forKeyPath: "loaiSach") as? String
                    namXuatBan.text = item.value(forKeyPath: "namXuatBan") as? String
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func tacGia(_ sender: Any) {
    }
    @IBAction func saveBook(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Sach", in: managedContext)!
        let book = NSManagedObject(entity: entity, insertInto: managedContext)
        
        guard let tenSachMoi = txtTenSachMoi.text,
        let maTacGiaMoi = txtMaTacGiaMoi.text,
        let loaiSachMoi = txtLoaiSachMoi.text,
        let namXuatBanMoi = txtNamXuatBanMoi.text else {
            return
        }
        
        book.setValue(maSach, forKeyPath: "maSach")
        book.setValue(tenSachMoi, forKeyPath: "tenSach")
        book.setValue(maTacGiaMoi, forKeyPath: "maTacGia")
        book.setValue(loaiSachMoi, forKeyPath: "loaiSach")
        book.setValue(namXuatBanMoi, forKeyPath: "namXuatBan")
        
        do {
            try managedContext.save()
            books.append(book)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        tenSach.text = tenSachMoi
        maTacGia.text = maTacGiaMoi
        loaiSach.text = loaiSachMoi
        namXuatBan.text = namXuatBanMoi
    }
    
   
}
