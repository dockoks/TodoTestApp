import Foundation
import CoreData


extension TodoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoEntity> {
        return NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    }

    @NSManaged public var todoId: String
    @NSManaged public var todoName: String
    @NSManaged public var todoDateCreated: Date
    @NSManaged public var todoDescription: String?
    @NSManaged public var todoIsCompleted: Bool

}

extension TodoEntity : Identifiable {
    public var id: String {
        return todoId
    }
}
