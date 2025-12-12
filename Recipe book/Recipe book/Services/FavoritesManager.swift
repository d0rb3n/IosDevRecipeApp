//
//  FavoritesManager.swift
//  Recipe book
//
//  Created by Ruslan Amrayev on 08.12.2025.
//

import Foundation


class FavoritesManager {
    static let shared = FavoritesManager()
    private init() {}
    
    
    private let favoritesKey = "FavoriteMeals"
    
    func saveFavorite(mealId: String, mealName: String, mealThumb: String) {
        var favorites = getFavorites()
        let favorite = FavoriteMeal(id: mealId, name: mealName, thumb: mealThumb)
        
        if !favorites.contains(where: { $0.id == mealId }) {
            favorites.append(favorite)
            saveFavorites(favorites)
        }
    }
    
    func removeFavorite(mealId: String) {
        var favorites = getFavorites()
        favorites.removeAll(where: {$0.id == mealId})
        saveFavorites(favorites)
    }
    
    func isFavorite(mealId: String) -> Bool {
        let favorites = getFavorites()
        return favorites.contains {$0.id == mealId}
        
    }
    
    func getFavorites() -> [FavoriteMeal] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode([FavoriteMeal].self, from: data) else {
            return []
        }
        return favorites
                
    }
    
    private func saveFavorites(_ favorites: [FavoriteMeal]) {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
        
    }
    
}
