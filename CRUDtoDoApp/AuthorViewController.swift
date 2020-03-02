//
//  AuthorViewController.swift
//  CRUDtoDoApp
//
//  Created by Hoang Trong Kien on 3/2/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit
import CoreData

class AuthorViewController: UIViewController {
    
    var authors: [NSManagedObject] = []
    var maTG = ""

    @IBOutlet weak var maTacGia: UILabel!
    @IBOutlet weak var tenTacGia: UILabel!
    @IBOutlet weak var queQuan: UILabel!
    @IBOutlet weak var txtTenTacGia: UITextField!
    @IBOutlet weak var txtQueQuan: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        maTacGia.text = maTG
        fetchData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookOfAuthorVC = segue.destination as! BooksOfAuthorViewController
        bookOfAuthorVC.author = maTG
    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TacGia")

        do {
            authors = try managedContext.fetch(fetchRequest)
            for item in authors {
                if item.value(forKeyPath: "maTacGia") as! String == maTG {
                    tenTacGia.text = item.value(forKeyPath: "tenTacGia") as? String
                    queQuan.text = item.value(forKeyPath: "queQuan") as? String
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    

    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAuthor(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "TacGia", in: managedContext)!
        let author = NSManagedObject(entity: entity, insertInto: managedContext)
        
        guard let tenTacGiaMoi = txtTenTacGia.text,
        let queQuanMoi = txtQueQuan.text else {
            return
        }
        
        author.setValue(maTG, forKey: "maTacGia")
        author.setValue(tenTacGiaMoi, forKey: "tenTacGia")
        author.setValue(queQuanMoi, forKey: "queQuan")
        
        do {
            try managedContext.save()
            authors.append(author)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        tenTacGia.text = tenTacGiaMoi
        queQuan.text = queQuanMoi
    }
    
}
