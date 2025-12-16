//
//  RecipeDetailViewController.swift
//  Recipe book
//
//  Created by Ruslan Amrayev on 11.12.2025.
//

import UIKit
import Kingfisher

class RecipeDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    // MARK: - Properties
    var mealId: String?
    private var mealDetail: MealDetail?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Проверка что все outlets подключены
        print("✅ mealImageView: \(mealImageView != nil)")
        print("✅ titleLabel: \(titleLabel != nil)")
        print("✅ areaLabel: \(areaLabel != nil)")
        print("✅ ingredientsLabel: \(ingredientsLabel != nil)")
        print("✅ instructionsLabel: \(instructionsLabel != nil)")
        print("✅ mealId: \(mealId ?? "NO ID")")
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.alwaysBounceVertical = true
            
        loadMealDetail()
    }
    
    // MARK: - Data Loading
    private func loadMealDetail() {
        guard let mealId = mealId else {
            print("❌ ERROR: No meal ID provided")
            showErrorAlert(message: "No meal ID provided")
            return
        }
        
        print("🔄 Loading meal with ID: \(mealId)")
        
        APIService.shared.fetchMealDetail(id: mealId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let meals):
                    print("✅ Success! Got \(meals.count) meals")
                    if let meal = meals.first {
                        print("✅ Meal name: \(meal.strMeal)")
                        self?.mealDetail = meal
                        self?.configureView(with: meal)
                    } else {
                        print("❌ ERROR: No meals in response")
                        self?.showErrorAlert(message: "Recipe not found")
                    }
                case .failure(let error):
                    print("❌ ERROR: \(error.localizedDescription)")
                    self?.showErrorAlert(message: "Failed to load recipe: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Configure View
    private func configureView(with meal: MealDetail) {
        print("🎨 Configuring view with meal: \(meal.strMeal)")
        
        // Название
        titleLabel.text = meal.strMeal
        print("   - Title set: \(meal.strMeal)")
        
        // Регион
        if let area = meal.strArea, !area.isEmpty {
            areaLabel.text = "🌍 \(area) Cuisine"
            areaLabel.isHidden = false
            print("   - Area set: \(area)")
        } else {
            areaLabel.isHidden = true
            print("   - Area hidden (no data)")
        }
        
        // Картинка
        if let imageURLString = meal.strMealThumb,
           let imageURL = URL(string: imageURLString) {
            print("   - Loading image from: \(imageURLString)")
            mealImageView.kf.setImage(
                with: imageURL,
                placeholder: UIImage(systemName: "photo"),
                options: [.transition(.fade(0.2))]
            )
        } else {
            print("   - No image URL")
        }
        
        // Ингредиенты
        print("   - Ingredients count: \(meal.ingredients.count)")
        var ingredientsText = ""
        for ingredient in meal.ingredients {
            if !ingredient.measure.isEmpty {
                ingredientsText += "• \(ingredient.measure) \(ingredient.name)\n"
            } else {
                ingredientsText += "• \(ingredient.name)\n"
            }
        }
        ingredientsLabel.text = ingredientsText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Инструкции
        if let instructions = meal.strInstructions, !instructions.isEmpty {
            instructionsLabel.text = instructions
            print("   - Instructions length: \(instructions.count) chars")
        } else {
            instructionsLabel.text = "No instructions available"
            print("   - No instructions")
        }
        
        print("✅ View configured successfully!")
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.scrollView.flashScrollIndicators()
            print("📏 ScrollView content size: \(self.scrollView.contentSize)")
            print("📏 ScrollView frame size: \(self.scrollView.frame.size)")
        }
    }
    
    // MARK: - Error Handling
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
