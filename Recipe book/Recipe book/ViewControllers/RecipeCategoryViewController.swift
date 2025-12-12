//
//  RecipeCategoryViewController.swift
//  Recipe book
//
//  Created by Ruslan Amrayev on 09.12.2025.
//

import UIKit
import Kingfisher

class RecipeCategoryViewController: UIViewController{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var category: String = "Breakfast"
    
    private var meals: [CategoryMeals] = []
    private var selectedMealId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadMeals()

        // Do any additional setup after loading the view.
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: "MealCell")
    }
    
    private func loadMeals() {
        APIService.shared.fetchMealsByCategory(category: category) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let meals):
                    self?.meals = meals
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error loading meals: \(error)")
                    self?.showErrorAlert(message: "Failed to load recipes")
                }
            }
            
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecipeDetail",
           let detailVC = segue.destination as? RecipeDetailViewController,
           let mealId = selectedMealId {
           detailVC.mealId = mealId
        }
    }
    
    
    private func toggleFavorite(for meal: CategoryMeals, cell: MealTableViewCell){
        if FavoritesManager.shared.isFavorite(mealId: meal.idMeal) {
            FavoritesManager.shared.removeFavorite(mealId: meal.idMeal)
        } else {
            FavoritesManager.shared.saveFavorite(mealId: meal.idMeal, mealName: meal.strMeal, mealThumb: meal.strMealThumb)
        }
        
        cell.updateFavoriteButton()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecipeCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as? MealTableViewCell else {
            return UITableViewCell()
        }
        
        let meal = meals[indexPath.row]
        cell.configure(with: meal)
        
        cell.onFavoriteButtonTapped = { [weak self] in
            self?.toggleFavorite(for: meal, cell: cell)
        }
        
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let meal = meals[indexPath.row]
        selectedMealId = meal.idMeal
        
        performSegue(withIdentifier: "ShowRecipeDetail", sender: self)
    }
    
}
