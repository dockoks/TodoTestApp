//
//  Presenter.swift
//  TodoTaskTestApp
//
//  Created by Danila Kokin on 11/9/24.
//

import Foundation

struct TodoListDTO: Codable {
    let todos: [TodoDTO]
}

struct TodoDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

