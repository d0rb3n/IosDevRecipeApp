//
//  RecipeDetailViewController.swift
//  Recipe book
//
//  Created by Ruslan Amrayev on 11.12.2025.
//

import UIKit
import Kingfisher

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    var mealId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMealDetail()
    }
    
    private func loadMealDetail() {
        guard let mealId = mealId else {
            showError("No meal ID provided")
            return
        }
        
        APIService.shared.fetchMealDetail(id: mealId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let meals):
                    if let meal = meals.first {
                        self?.configure(with: meal)
                    } else {
                        self?.showError("Recipe not found")
                    }
                case .failure(let error):
                    self?.showError("Failed to load recipe: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func configure(with meal: MealDetail){
        titleLabel.text = meal.strMeal
        
        if let area = meal.strArea, !area.isEmpty {
            areaLabel.text = "🌍 \(area) Cuisine"
            areaLabel.isHidden = false
        } else {
            areaLabel.isHidden = true
        }

        if let imageURLString = meal.strMealThumb,
           let imageURL = URL(string: imageURLString) {
            mealImageView.kf.setImage(with: imageURL)
        }

        var ingredientsText = ""
        for ingredient in meal.ingredients {
            if !ingredient.measure.isEmpty {
                ingredientsText += "• \(ingredient.measure) \(ingredient.name)\n"
            } else {
                ingredientsText += "• \(ingredient.name)\n"
            }
        }
        ingredientsLabel.text = ingredientsText.trimmingCharacters(in: .whitespacesAndNewlines)

        if let instructions = meal.strInstructions, !instructions.isEmpty {
            instructionsTextView.text = instructions
        } else {
            instructionsTextView.text = "No instructions available"
        }

    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
