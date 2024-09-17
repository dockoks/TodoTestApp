import Foundation
import CoreData

protocol TodoServiceProtocol {
    func loadInitialDataIfNeeded(completion: @escaping (Result<Void, Error>) -> Void)
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void)
    func addTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void)
    func updateTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void)
}

final class TodoService: TodoServiceProtocol {
    static let shared = TodoService()
    
    private let apiClient: APIClient
    private let coreDataManager: CoreDataManager
    private let userDefaultsService: UserDefaultsService

    private init(
        apiClient: APIClient = APIClient.shared,
        coreDataManager: CoreDataManager = CoreDataManager.shared,
        userDefaultsService: UserDefaultsService = UserDefaultsService.shared
    ) {
        self.apiClient = apiClient
        self.coreDataManager = coreDataManager
        self.userDefaultsService = userDefaultsService
    }

    // MARK: - Load Initial Data

    func loadInitialDataIfNeeded(completion: @escaping (Result<Void, Error>) -> Void) {
        guard userDefaultsService.isFirstLaunch else {
            completion(.success(()))
            return
        }

        apiClient.fetchTodos { [weak self] result in
            switch result {
            case .success(let todoDTOs):
                guard let self = self else { return }
                let todos = todoDTOs.map { Todo(from: $0) }
                let backgroundContext = self.coreDataManager.persistentContainer.newBackgroundContext()

                backgroundContext.perform {
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TodoEntity.fetchRequest()
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    do {
                        try backgroundContext.execute(deleteRequest)
                        try backgroundContext.save()
                    } catch {
                        
                    }

                    // Save new data
                    for todo in todos {
                        let entity = TodoEntity(context: backgroundContext)
                        entity.todoId = todo.id
                        entity.todoName = todo.name
                        entity.todoDescription = todo.description
                        entity.todoDateCreated = todo.dateCreated
                        entity.todoIsCompleted = todo.isCompleted
                    }
                    do {
                        try backgroundContext.save()
                        self.userDefaultsService.setFirstLaunchCompleted()
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }


    // MARK: - Fetch Todos

    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        let mainContext = coreDataManager.persistentContainer.viewContext
        mainContext.perform {
            let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            do {
                let entities = try mainContext.fetch(fetchRequest)
                let todos = entities.map { Todo(from: $0) }
                let sortedTodos = todos.sorted { $0.id < $1.id }
                DispatchQueue.main.async {
                    completion(.success(sortedTodos))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: - Add Todo

    func addTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void) {
        let backgroundContext = coreDataManager.persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let entity = TodoEntity(context: backgroundContext)
            entity.todoId = todo.id
            entity.todoName = todo.name
            entity.todoDescription = todo.description
            entity.todoDateCreated = todo.dateCreated
            entity.todoIsCompleted = todo.isCompleted
            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: - Update Todo

    func updateTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void) {
        let backgroundContext = coreDataManager.persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "todoId == %@", todo.id)
            do {
                if let entity = try backgroundContext.fetch(fetchRequest).first {
                    entity.todoName = todo.name
                    entity.todoDescription = todo.description
                    entity.todoIsCompleted = todo.isCompleted
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } else {
                    DispatchQueue.main.async {
                        let error = NSError(domain: "TodoService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Todo not found"])
                        completion(.failure(error))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: - Delete Todo

    func deleteTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void) {
        let backgroundContext = coreDataManager.persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "todoId == %@", todo.id)
            do {
                if let entity = try backgroundContext.fetch(fetchRequest).first {
                    backgroundContext.delete(entity)
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } else {
                    DispatchQueue.main.async {
                        let error = NSError(domain: "TodoService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Todo not found"])
                        completion(.failure(error))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
