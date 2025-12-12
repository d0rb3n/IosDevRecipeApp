//
//  MealTableViewCell.swift
//  Recipe book
//
//  Created by Ruslan Amrayev on 11.12.2025.


import UIKit
import Kingfisher

class MealTableViewCell: UITableViewCell {
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var onFavoriteButtonTapped: (() -> Void)?
    
    
    var mealId: String?
    var mealName: String?
    var mealThumb: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    
    private func setupUI() {
        mealImageView.contentMode = .scaleAspectFill
        mealImageView.clipsToBounds = true
        mealImageView.layer.cornerRadius = 8
        mealImageView.backgroundColor = .systemGray5
        
        nameLabel.numberOfLines = 2
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        favoriteButton.tintColor = .systemRed
    }
    
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton){
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
            }
        }
        
        
        onFavoriteButtonTapped?()
    }
    
    
    func configure(with meal: CategoryMeals) {
        self.mealId = meal.idMeal
        self.mealName = meal.strMeal
        self.mealThumb = meal.strMealThumb
        
        
        nameLabel.text = meal.strMeal
        
        
        if let url = URL(string: meal.strMealThumb) {
            mealImageView.kf.setImage(with: url)
        } else {
            mealImageView.image = UIImage(systemName: "photo")
        }
        
        updateFavoriteButton()
    }
    
    
    func updateFavoriteButton() {
        guard let mealId = mealId else { return }
        let isFavorite = FavoritesManager.shared.isFavorite(mealId:  mealId)
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        
    }
    
}
