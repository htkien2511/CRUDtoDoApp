//
//  ViewController.swift
//  CRUDtoDoApp
//
//  Created by Hoang Trong Kien on 3/1/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {
    
    // MARK: - Properties
    var categoryGroup = CategoryGroup()
    var categories: [NSManagedObject] = []
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
        title = "Phiếu mượn"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryGroup.fetchData()
        categories = categoryGroup.categories
        
    }
    
    // MARK: - Action
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? CategoryDetailViewController else {
            return
        }
        let selectedRowIndex = self.tableView.indexPathForSelectedRow
        let category = categories[selectedRowIndex!.row]
        
        detailVC.soPhieu = category.value(forKeyPath: "soPhieu") as! String
        detailVC.nguoiMuon = category.value(forKeyPath: "nguoiMuon") as! String
        
    }
    
    @IBAction func addCategory(_ sender: Any) {
        let alert = UIAlertController(title: "Phiếu mượn",
                                      message: "Thêm 1 phiếu",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text,
                                            let personField = alert.textFields?.last,
                                            let personToSave = personField.text else {
                                                return
                                        }
                                        
                                        
                                        self.categoryGroup.save(soPhieu: nameToSave, nguoiMuon: personToSave)
                                        self.categories = self.categoryGroup.categories
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        self.tableView.register(textFieldCell, forCellReuseIdentifier: "categoryCell")
    }
    
}

// MARK: - Table View Data Source
extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categories[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        
        
        cell.soPhieu.text = category.value(forKeyPath: "soPhieu") as? String
        cell.tenNguoiMuon.text = category.value(forKeyPath: "nguoiMuon") as? String
        
        cell.delegate = self
        cell.index = indexPath
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
}

// MARK: - Table View Delegate
extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(identifier: "detail") as! CategoryDetailViewController
        
        let selectedRowIndex = self.tableView.indexPathForSelectedRow
        let category = categories[selectedRowIndex!.row]
        
        detailVC.soPhieu = category.value(forKeyPath: "soPhieu") as! String
        if category.value(forKeyPath: "nguoiMuon") != nil {
            detailVC.nguoiMuon = category.value(forKeyPath: "nguoiMuon") as! String
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        //self.present(detailVC, animated: true, completion: nil)
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    
}

// MARK: - Delete 1 category
extension CategoriesViewController: DeleteCategory {
    func deleteCategory(index: IndexPath) {
        categoryGroup.deleteCategory(index: index)
        categories = categoryGroup.categories
        self.categories.remove(at: index.row)
        self.tableView.deleteRows(at: [index], with: .automatic)
        
    }
    
    
}
