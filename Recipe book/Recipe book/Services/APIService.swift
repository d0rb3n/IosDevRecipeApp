//
//  APIService.swift
//  Recipe book
//
//  Created by Ruslan Amrayev on 10.12.2025.
//

import Foundation
import Alamofire


class APIService {
    static let shared = APIService()
    private init() {}
    
    private let baseURL = "https://www.themealdb.com/api/json/v1/1"
    
    
    func fetchMealsByCategory(category: String, completion: @escaping (Result<[CategoryMeals], Error>) -> Void){
        let url = "\(baseURL)/filter.php"
        let parameters: Parameters = ["c": category]
        
        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: CategoryMealsResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data.meals ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }

            }
    }
    
    
    func fetchMealDetail(id: String, completion: @escaping (Result<[MealDetail], Error>) -> Void) {
        let url = "\(baseURL)/lookup.php"
        let parameters: Parameters = ["i": id]
        
        
        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: MealDetailResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data.meals ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }
                
            }
    }
}
