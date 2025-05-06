//
//  NetworkService.swift
//  ToDoList
//
//  Created by Ксения Маричева on 01.05.2025.
//

import Foundation

class NetworkService {
    
    static func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
           guard let url = URL(string: "https://dummyjson.com/todos") else { return }

           URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }

               guard let data = data else {
                   completion(.failure(NSError(domain: "no data", code: -1)))
                   return
               }

               do {
                   let decoded = try JSONDecoder().decode(TodoResponse.self, from: data)
                   DispatchQueue.main.async {
                       completion(.success(decoded.todos))
                   }
               } catch {
                   completion(.failure(error))
               }
           }.resume()
       }
}
