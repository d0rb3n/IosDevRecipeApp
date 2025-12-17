//
//  MealDetail.swift
//  Recipe book
//
//  Created by Ruslan Amrayev on 08.12.2025.
//

import Foundation


struct MealDetailResponse: Codable {
    let meals: [MealDetail]?
}


struct MealDetail: Codable {
    let idMeal: String
    let strMeal: String
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String? //little image
    
    let ingredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case idMeal
        case strMeal
        case strArea
        case strInstructions
        case strMealThumb
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strArea = try container.decodeIfPresent(String.self, forKey: .strArea)
        strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempIngredients: [Ingredient] = []
        
        for i in 1...20 {
            let ingredientKey = DynamicCodingKeys(stringValue: "strIngredient\(i)")!
            let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(i)")!
            
            let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: ingredientKey)
            let measure = try dynamicContainer.decodeIfPresent(String.self, forKey: measureKey)
            
            if let ing = ingredient?.trimmingCharacters(in: .whitespacesAndNewlines), !ing.isEmpty {
                let meas = measure?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                
                tempIngredients.append(Ingredient(name: ing, measure: meas))
            }
                
        }
        
        ingredients = tempIngredients
        
        
    }
    
    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {self.stringValue = stringValue}
        var intValue: Int? {nil}
        init?(intValue: Int) {nil}
    }
    
    
}


struct Ingredient{
    let name: String
    let measure: String
}
