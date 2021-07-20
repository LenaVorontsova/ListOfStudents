
import UIKit
import CoreData

class ListDetailVC: UIViewController {
    
    var selectedList: List? = nil

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var sureNameTF: UITextField!
    @IBOutlet weak var gpaTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedList != nil {
            nameTF.text = selectedList?.name
            sureNameTF.text = selectedList?.sureName
            gpaTF.text = selectedList?.gpa
        }
    }

    @IBAction func saveAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Attention!", message: "Invalid characters entered", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if ((nameTF.text?.isValidName()==true) && (sureNameTF.text?.isValidName() == true) && (gpaTF.text?.isValidGPA() == true)) {
        
        if selectedList == nil {
            let entity = NSEntityDescription.entity(forEntityName: "List", in: context)
            let newList = List(entity: entity!, insertInto: context)
            newList.id = studentsList.count as NSNumber
            newList.name = nameTF.text
            newList.sureName = sureNameTF.text
            newList.gpa = gpaTF.text
            
            do {
                try context.save()
                studentsList.append(newList)
                navigationController?.popViewController(animated: true)
            }
            catch {
                print("Context save error")
            }
        }
        else {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let list = result as! List
                    if list == selectedList {
                        list.name = nameTF.text
                        list.sureName = sureNameTF.text
                        list.gpa = gpaTF.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch  {
                print("Fetch Failed")
            }
        }
        }
        else {
            present(alert, animated: true, completion: nil)
       }
        
    }
    @IBAction func deleteStudent(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let list = result as! List
                if list == selectedList {
                    list.deletedDate = Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        }
        catch  {
            print("Fetch Failed")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //@IBAction func tap(_ sender: Any) {
    //}
}

extension String {
    func isValidName() -> Bool {
        let inputRegEx = "^[a-zA-Z\\_]{2,25}$"
        let inputPred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputPred.evaluate(with: self)
    }
    
    func isValidGPA() -> Bool {
        let inputRegEx = "^[1-5\\_]{1,1}$"
        let inputPred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputPred.evaluate(with: self)
    }
}

