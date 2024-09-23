import Foundation

struct TodoList: Codable {
    let todos: [Todo]
    
    init(from dto: TodoListDTO) {
        self.todos = dto.todos.map { Todo(from: $0) }
    }
}

struct Todo: Codable, Equatable {
    let id: String
    var name: String
    var description: String?
    let dateCreated: Date
    var isCompleted: Bool
    
    init(from dto: TodoDTO) {
        self.id = String(dto.id)
        self.name = dto.todo
        self.description = nil
        self.isCompleted = dto.completed
        self.dateCreated = Date.now
    }
    
    init(from entity: TodoEntity) {
        self.id = entity.todoId
        self.name = entity.todoName
        self.description = entity.todoDescription
        self.isCompleted = entity.todoIsCompleted
        self.dateCreated = entity.todoDateCreated
    }
    
    init(
        id: String = UUID().uuidString,
        name: String,
        description: String?,
        dateCreated: Date = .now,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.isCompleted = isCompleted
        self.dateCreated = dateCreated
    }
}
