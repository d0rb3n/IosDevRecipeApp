//
//  RecipeCategoryViewController.swift
//  Recipe book
//
//  Created by Ruslan Amrayev on 09.12.2025.
//

import UIKit
import Kingfisher

class RecipeCategoryViewController: UIViewController, UISearchBarDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var category: String = "Breakfast"
    
    private var allMeals: [CategoryMeals] = []
    private var filteredMeals: [CategoryMeals] = []
    private var selectedMealId: String?
    private var isSearching: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        loadMeals()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSearchBar(){
        searchBar.delegate = self
    }
    
    private func loadMeals() {
        APIService.shared.fetchMealsByCategory(category: category) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let meals):
                    self?.allMeals = meals
                    self?.filteredMeals = meals
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error loading meals: \(error)")
                    self?.showErrorAlert(message: "Failed to load recipes")
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText.isEmpty{
            isSearching = false
            filteredMeals = allMeals
        } else {
            isSearching = true
            filteredMeals = allMeals.filter { meal in
                meal.strMeal.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
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
}

extension RecipeCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if filteredMeals.isEmpty && isSearching {
            return 1
        }
        return filteredMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if filteredMeals.isEmpty && isSearching {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Not Found"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .secondaryLabel
            cell.selectionStyle = .none
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as? MealTableViewCell else {
            return UITableViewCell()
        }
        
        let meal = filteredMeals[indexPath.row]
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
        
        if filteredMeals.isEmpty && isSearching {
            return
        }
        
        let meal = filteredMeals[indexPath.row]
        selectedMealId = meal.idMeal
        
        performSegue(withIdentifier: "ShowRecipeDetail", sender: self)
    }
}
