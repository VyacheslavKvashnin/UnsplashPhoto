//
//  DatabaseServices.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 04.06.2022.
//

import Foundation

enum NetworkError: String, Error {
    case badURL = "No connection to url address."
    case invalidData = "The data received from the server was invalid. Please try again."
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    let token = "EeIzrN0doNb4XPlVf2cb7-ObHtvadTYOXRVEXetBUgw"
  
    func fetchPhotos(query: String, completion: @escaping(Result<[Results], NetworkError>) -> Void) {

        guard let urlRandom = URL(string: "https://api.unsplash.com/photos/random/?count=30&query=\(query)") else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: urlRandom)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidData))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return }
            do {
                let result = try JSONDecoder().decode([Results].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
}
