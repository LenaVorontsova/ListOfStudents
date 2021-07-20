
import Foundation
import UIKit
import CoreData

var studentsList = [List]()

class ListTableView: UITableViewController {
    
    var firstLoad = true
    
    func nonDeletedList() -> [List] {
        var noDeletedStudentsList = [List]()
        for student in studentsList {
            if student.deletedDate == nil {
                noDeletedStudentsList.append(student)
            }
        }
        
        return noDeletedStudentsList
    }
    
    override func viewDidLoad() {
        if firstLoad {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let list = result as! List
                    studentsList.append(list)
                }
            }
            catch  {
                print("Fetch Failed")
            }
        }
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = tableView.dequeueReusableCell(withIdentifier: "ListCellID", for: indexPath) as! ListCell
        
        let thisList: List!
        thisList = nonDeletedList()[indexPath.row]
        
        listCell.nameLabel.text = thisList.name
        listCell.sureNameLabel.text = thisList.sureName
        listCell.gpaLabel.text = thisList.gpa
        
        return listCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedList().count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editList" {
            let indexPath = tableView.indexPathForSelectedRow!
            let listDetail = segue.destination as? ListDetailVC
             
            let selectedList: List!
            selectedList = nonDeletedList()[indexPath.row]
            listDetail!.selectedList = selectedList
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
