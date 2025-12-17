# 🍳 Recipe Book

A beautiful iOS recipe application built with Swift and UIKit that allows users to browse, search, and save their favorite recipes.

![iOS](https://img.shields.io/badge/iOS-13.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 📱 Features

### Core Features
- **Browse Recipes by Category**: Explore recipes in Breakfast, Dessert, and Starter categories
- **Search Functionality**: Quickly find recipes by name with real-time search
- **Favorites Management**: Save your favorite recipes for quick access
- **Recipe Details**: View complete recipe information including ingredients, measurements, and cooking instructions
- **Beautiful UI**: Clean, modern interface with smooth animations

### Technical Features
- Tab-based navigation with 4 tabs
- Custom table view cells with programmatic and Storyboard support
- Image caching for optimal performance
- Persistent storage for favorites using UserDefaults
- Networking with Alamofire
- Image loading with Kingfisher


## 🎨 Screenshots

### Main Screens
```
┌─────────────────────────────────────────────────────┐
│  Breakfast    Dessert    Starter    Favorites       │
├─────────────────────────────────────────────────────┤
│  🔍 Search recipes...                               │
├─────────────────────────────────────────────────────┤
│  [🥞] Pancakes                               ❤️     │
│  [🍳] Omelette                               ❤️     │
│  [🧇] Waffles                                ❤️     │
│  [🥓] Bacon and Eggs                         ❤️     │
└─────────────────────────────────────────────────────┘
```

## 🛠 Technologies Used

### Core
- **Language**: Swift 5
- **UI Framework**: UIKit
- **Architecture**: MVC (Model-View-Controller)
- **Interface**: Storyboard + Programmatic UI

### Third-Party Libraries
- **[Alamofire](https://github.com/Alamofire/Alamofire)** (5.9+) - Elegant HTTP Networking
- **[Kingfisher](https://github.com/onevcat/Kingfisher)** (7.10+) - Image downloading and caching

### API
- **[TheMealDB API](https://www.themealdb.com/api.php)** - Free meal database with images and recipes

## 📋 Requirements

- iOS 13.0+
- Xcode 14.0+
- Swift 5.0+
- CocoaPods or Swift Package Manager

## 🚀 Installation

### 1. Clone the Repository
```bash
git clone https://github.com/AmrayevRRtr/IosDevRecipeApp
cd recipe-book
```

### 2. Install Dependencies

#### Option A: Swift Package Manager (Recommended)
Dependencies are already configured in the project. Simply open the project in Xcode:
```bash
open RecipeBook.xcodeproj
```
Xcode will automatically resolve and download packages.

#### Option B: CocoaPods
If using CocoaPods, install dependencies:
```bash
pod install
open RecipeBook.xcworkspace
```


### 4. Build and Run
1. Select your target device or simulator
2. Press `Cmd + R` to build and run

## 📁 Project Structure

```
RecipeBook/
├── Models/
│   ├── Category.swift              # Category data model
│   ├── CategoryMeal.swift          # Meal in category model
│   ├── MealDetail.swift            # Detailed meal model
│   ├── Ingredient.swift            # Ingredient model
│   └── FavoriteMeal.swift          # Favorite meal model
│
├── Services/
│   ├── APIService.swift            # Networking layer (Alamofire)
│   └── FavoritesManager.swift      # Favorites persistence
│
├── ViewControllers/
│   ├── RecipeCategoryViewController.swift    # Category tabs (Breakfast, etc.)
│   ├── FavoritesViewController.swift         # Favorites tab
│   └── RecipeDetailViewController.swift      # Recipe details
│
├── Views/
│   └── MealTableViewCell.swift     # Custom table view cell
│
├── Storyboards/
│   ├── Main.storyboard             # Main interface
│   └── LaunchScreen.storyboard     # Launch screen
│
├── Supporting Files/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── Info.plist
│   └── Assets.xcassets
│
└── README.md
```



## 🎯 Usage

### Browse Recipes
1. Launch the app
2. Navigate through tabs: Breakfast, Dessert, or Starter
3. Scroll through the recipe list
4. Tap on any recipe to view details

### Search Recipes
1. Pull down on any category screen to reveal search bar
2. Type recipe name
3. Results filter in real-time

### Add to Favorites
1. Tap the ❤️ button on any recipe cell
2. Recipe is instantly added to Favorites tab
3. Tap ❤️ again to remove from favorites

### View Recipe Details
1. Tap on any recipe card
2. View recipe image, name, and origin
3. See complete ingredient list with measurements
4. Read cooking instructions
5. Tap ❤️ in navigation bar to favorite/unfavorite

### Manage Favorites
1. Go to Favorites tab
2. View all saved recipes
3. Tap ❤️ to remove from favorites


## 🔑 API Reference

### TheMealDB API Endpoints Used

```
Base URL: https://www.themealdb.com/api/json/v1/1
```

#### Get Meals by Category
```
GET /filter.php?c={category}
Example: /filter.php?c=Breakfast
```

#### Get Meal Details
```
GET /lookup.php?i={mealId}
Example: /lookup.php?i=52772
```

### Response Example

```json
{
  "meals": [
    {
      "idMeal": "52772",
      "strMeal": "Teriyaki Chicken Casserole",
      "strMealThumb": "https://www.themealdb.com/images/media/meals/...",
      "strInstructions": "Preheat oven to 350°F...",
      "strIngredient1": "Chicken",
      "strMeasure1": "3/4 pound",
      ...
    }
  ]
}
```

## 🧩 Key Components

### MealTableViewCell
Custom table view cell with:
- Recipe image 
- Recipe name (2 lines)
- Favorite button (❤️)


### APIService
Centralized networking with Alamofire:
- `fetchMealsByCategory(category:completion:)` - Get meals by category
- `fetchMealDetail(id:completion:)` - Get meal details by ID

### FavoritesManager
Favorites persistence using UserDefaults:
- `saveFavorite(mealId:mealName:mealThumb:)` - Add to favorites
- `removeFavorite(mealId:)` - Remove from favorites
- `isFavorite(mealId:) -> Bool` - Check favorite status
- `getFavorites() -> [FavoriteMeal]` - Get all favorites

## 🎨 Customization

### Change Categories
Edit categories in `SceneDelegate.swift`:
```swift
category = tabBarItem.title ?? "Breakfast" // Change to any valid category
```

Available categories: Beef, Chicken, Dessert, Lamb, Miscellaneous, Pasta, Pork, Seafood, Side, Starter, Vegan, Vegetarian, Breakfast, Goat

### Modify Cell Height
In any ViewController:
```swift
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 110  // Change this value
}
```

### Change Colors
In `MealTableViewCell.swift`:
```swift
favoriteButton.tintColor = .systemPink  // Change heart color
```

## 🐛 Troubleshooting

### Images Not Loading
- Check Info.plist for App Transport Security settings
- Verify internet connection
- Check Kingfisher installation

### Favorites Not Persisting
- Check UserDefaults access
- Verify FavoritesManager is saving correctly
- Check app permissions

### Cell Not Displaying
- Verify Custom Class is set in Storyboard
- Check IBOutlets are connected
- Ensure Cell Identifier matches code

### Search Not Working
- Verify UISearchController is properly configured
- Check delegate methods are implemented

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## 👨‍💻 Author

**Ruslan Amrayev && Makhmutov Darkhan**
- GitHub: (https://github.com/AmrayevRRtr/IosDevRecipeApp)


## 🙏 Acknowledgments

- [TheMealDB](https://www.themealdb.com/) for providing the free recipe API
- [Alamofire](https://github.com/Alamofire/Alamofire) for elegant networking
- [Kingfisher](https://github.com/onevcat/Kingfisher) for image caching
- Apple's Human Interface Guidelines for design inspiration

## 📝 TODO / Future Features

- [ ] Add more categories (Seafood, Vegetarian, etc.)
- [ ] Implement recipe sharing functionality
- [ ] Add cooking timer
- [ ] Support for multiple languages
- [ ] Dark mode optimization
- [ ] Offline mode with cached recipes
- [ ] User accounts and cloud sync
- [ ] Recipe rating system
- [ ] Shopping list feature
- [ ] Meal planning calendar

## 📸 Demo Video

[Add link to demo video here]

## 🔗 Links

- [TheMealDB API Documentation](https://www.themealdb.com/api.php)
- [Alamofire Documentation](https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md)
- [Kingfisher Documentation](https://github.com/onevcat/Kingfisher/wiki)

---

⭐ If you found this project helpful, please give it a star!

**Made with ❤️ and Swift**
