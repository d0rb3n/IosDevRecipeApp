//
//  FavoritesViewController.swift
//  Recipe book
//
//  Created by Ruslan Amrayev on 11.12.2025.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    private var favorites: [FavoriteMeal] = []
    private var selectedMealId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Favorite Cell")
    }
    
    private func loadFavorites() {
        favorites = FavoritesManager.shared.getFavorites()
        tableView.reloadData()
        
        
        if favorites.isEmpty {
            tableView.setEmptyMessage("No favorites yet\n\nAdd recipes by tapping ❤️")
        } else {
            tableView.restore()
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecipeDetail",
           let detailVC = segue.destination as? RecipeDetailViewController,
           let mealId = selectedMealId {
            detailVC.mealId = mealId
        }
    }
    
    private func removeFavorite(mealId: String) {
        FavoritesManager.shared.removeFavorite(mealId: mealId)
        loadFavorites()
        
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


extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as?
                MealTableViewCell else {
            return UITableViewCell()
        }
        
        let favorite = favorites[indexPath.row]
        
        let meal = CategoryMeals(
            strMeal: favorite.name, strMealThumb: favorite.thumb, idMeal: favorite.id
        )
        
        cell.configure(with: meal)
        
        cell.onFavoriteButtonTapped = { [weak self] in
            self?.removeFavorite(mealId: favorite.id)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let favorite = favorites[indexPath.row]
        selectedMealId = favorite.id
        
        performSegue(withIdentifier: "ShowRecipeDetail", sender: self)
    }
}


extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 17)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore(){
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
