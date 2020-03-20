//
//  BooksOfAuthorViewController.swift
//  CRUDtoDoApp
//
//  Created by Hoang Trong Kien on 3/2/20.
//  Copyright © 2020 Hoang Trong Kien. All rights reserved.
//

import UIKit
import CoreData

class BooksOfAuthorViewController: UITableViewController {

    var books: [NSManagedObject] = []
    var author = ""
    var booksOfAuthor: [String] = []
    var codeOfBooks: [String] = []
    
    
    @IBOutlet weak var bookList: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sách của \(author)"
        fetchData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookVC = segue.destination as! BookViewController
        let selectedRowIndex = bookList.indexPathForSelectedRow
        bookVC.maSach = codeOfBooks[selectedRowIndex!.row]
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
                if item.value(forKeyPath: "maTacGia") as! String == author {
                    let tenSach = item.value(forKey: "tenSach") as! String
                    let maSach = item.value(forKeyPath: "maSach") as! String
                    booksOfAuthor.append(tenSach)
                    codeOfBooks.append(maSach)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return booksOfAuthor.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookcell", for: indexPath) as! BookCell

        cell.tenSach.text = booksOfAuthor[indexPath.row]
        cell.maSach.text = codeOfBooks[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80

    }

    

}

// MARK: - DeleteBook
extension BooksOfAuthorViewController: DeleteBook {
    func deleteBook(indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(books[indexPath.row])
        
        
        
        do {
            try managedContext.save()
            bookList.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.books.remove(at: indexPath.row)
        self.booksOfAuthor.remove(at: indexPath.row)
        self.codeOfBooks.remove(at: indexPath.row)
        self.bookList.deleteRows(at: [indexPath], with: .automatic)
        
    }
}





// MARK: - BookCell
protocol DeleteBook {
    func deleteBook(indexPath: IndexPath)
}

class BookCell: UITableViewCell {
    
    var delegate: DeleteBook?
    var indexPath: IndexPath?
    
    @IBOutlet weak var tenSach: UILabel!
    @IBOutlet weak var maSach: UILabel!
   
    @IBAction func deleteBook(_ sender: Any) {
        delegate?.deleteBook(indexPath: indexPath!)
    }
}
