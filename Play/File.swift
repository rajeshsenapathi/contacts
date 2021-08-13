//
//  File.swift
//  Play
//
//  Created by Rajesh Senapathi on 18/05/1400 AP.
//

import Foundation

enum HttpMethod{
    case GET
    case POST
}

class APIservice{
    
    static let shared = APIservice()
    
    func makeServiceCall(method : HttpMethod,url :String,completion : @escaping (Result<[WelcomeElement],Error>) -> Void){
        
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in

                guard let response = response as? HTTPURLResponse else {
                    print("HTTPURLResponse error")
                    return
                }

                guard 200 ... 299 ~= response.statusCode else {
                    print("Status Code error \(response.statusCode)")
                    return
                }

                guard let data = data  else {
                    print("No Data")
                    return
                }
                
                do{
                    let decoder = JSONDecoder()
                   let json = try decoder.decode([WelcomeElement].self, from: data)
                    completion(.success(json))
                    
                }
                catch{
                    completion(.failure(error.localizedDescription as! Error))
                }
            }.resume()
            
        }
        
    }
    
}
