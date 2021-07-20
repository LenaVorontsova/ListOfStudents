
import CoreData

@objc(List)
class List: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var sureName: String!
    @NSManaged var gpa: String!
    @NSManaged var deletedDate: Date?

    
}
