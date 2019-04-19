//
//  CategoriesViewController.swift
//  QuizApp
//
//  Created by Илья on 4/16/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet private weak var ibActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    
    private var categories: [String:[String]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        ibActivityIndicator.startAnimating()
        DataManager.instance.loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(categoriesWereLoaded), name: .CategoriesWereLoaded, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .CategoriesWereLoaded, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuestionsList"{
            if let destVC = segue.destination as? QuestionsViewController{
                let cell = sender as? UITableViewCell
                destVC.categoryName = cell?.textLabel?.text
            }
        }
    }

}

//MARK: - Notifications implementation
extension CategoriesViewController{
    @objc func categoriesWereLoaded(){
        ibActivityIndicator.stopAnimating()
        categories = DataManager.instance.categoriesDictionary()
        UIView.transition(with: tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        }, completion: nil)
    }
}

//MARK: - Table view settings
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(categories.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(categories.keys)[section]
        return categories[key]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let key = Array(categories.keys)[indexPath.section]
        let categoriesArray = categories[key] ?? []
        cell.textLabel?.text = categoriesArray[indexPath.row]
        return cell
    }
    
    
}
