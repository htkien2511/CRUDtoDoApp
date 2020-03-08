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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
