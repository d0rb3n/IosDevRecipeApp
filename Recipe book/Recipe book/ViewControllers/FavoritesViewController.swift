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

        // Do any additional setup after loading the view.
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Favorite Cell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Favorite cell", for: indexPath)
        
        let favorite = favorites[indexPath.row]
        
        
        cell.textLabel?.text = favorite.name
        
        if let url = URL(string: favorite.thumb) {
            cell.imageView?.kf.setImage(with: url,
                                        placeholder: UIImage(systemName: "photo"),
                                        options: [
                                            .transition(.fade(0.2)),
                                            .cacheOriginalImage
                                        ])
        } else {
            cell.imageView?.image = UIImage(systemName: "photo")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let favorite = favorites[indexPath.row]
        selectedMealId = favorite.id
        
        performSegue(withIdentifier: "ShowRecipeDetail", sender: self)
    }
}
