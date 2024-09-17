import Foundation

protocol APIClientProtocol: AnyObject {
    func fetchTodos(completion: @escaping (Result<[TodoDTO], Error>) -> Void)
}

final class APIClient {
    private init() {}
    static let shared = APIClient()
    
    enum APIHandler {
        static let todos = "https://dummyjson.com/todos"
    }
}

extension APIClient: APIClientProtocol {
    func fetchTodos(completion: @escaping (Result<[TodoDTO], Error>) -> Void) {
        guard let url = URL(string: APIHandler.todos) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
                return
            }
            do {
                let todoListDTO = try JSONDecoder().decode(TodoListDTO.self, from: data)
                completion(.success(todoListDTO.todos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

