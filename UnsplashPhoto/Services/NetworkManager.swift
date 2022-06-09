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
    
    private func request(searchTerm: String, completion: @escaping(Data?, Error?) -> Void) {
        let parameters = prepareParameters(searchTerm: searchTerm)
        let url = url(param: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "GET"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID \(token)"
        return headers
    }
    
    private func prepareParameters(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["count"] = String(30)
        return parameters
    }
    
    private func url(param: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos/random/"
        components.queryItems = param.map {
            URLQueryItem(name: $0, value: $1)
        }
        return components.url ?? URL(fileURLWithPath: "")
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping(Data?, Error?) -> Void) ->
    URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
    func fetchPhotos(query: String, completion: @escaping(Result<[Results], NetworkError>) -> Void) {
        request(searchTerm: query) { data, error in
            if error != nil {
                completion(.failure(.badURL))
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode([Results].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.invalidData))
            }
        }
    }
}
