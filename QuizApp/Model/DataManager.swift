//
//  DataManager.swift
//  QuizApp
//
//  Created by Илья on 4/16/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class DataManager{
    private init(){}
    static let instance = DataManager()
    
    private var categoriesArray: [Category] = []
    var questions: [Question] = []
    
    
    //MARK: - Load data functions
    func loadCategories(){
        Alamofire.request("https://opentdb.com/api_category.php").responseJSON { [weak self] (response) in
            guard let value = response.result.value else { return }
            let jsonObject = JSON(value)
            guard let  jsonArray = jsonObject["trivia_categories"].array else { return }
            for object in jsonArray{
                guard let category = Category(json: object) else { continue }
                self?.categoriesArray.append(category)
            }
            NotificationCenter.default.post(name: .CategoriesWereLoaded, object: nil)
        }
    }
    
    func loadQuestions(for category: Category){
        let amountOfQuestionsRequestUrl = "https://opentdb.com/api_count.php?category=\(category.id)"
        Alamofire.request(amountOfQuestionsRequestUrl).responseJSON { (response) in
            guard let value = response.result.value else { return }
            let jsonObject = JSON(value)
            let amount = jsonObject["category_question_count"]["total_medium_question_count"].intValue
            let requestURL = "https://opentdb.com/api.php?amount=\(amount)&category=\(category.id)&difficulty=medium"
            Alamofire.request(requestURL).responseJSON(completionHandler: { [weak self](response) in
                self?.questions = []
                guard let value = response.result.value else { return }
                let jsonObject = JSON(value)
                let jsonArray = jsonObject["results"].arrayValue
                for object in jsonArray{
                    guard let question = Question(json: object) else { continue }
                    self?.questions.append(question)
                }
                NotificationCenter.default.post(name: .QuestionsWereLoaded, object: nil)
            })
        }
    }
    
    //MARK: - Manage data functions
    func categoriesDictionary() -> [String:[String]]{
        var categoriesDictionary: [String:[String]] = [:]
        for category in categoriesArray{
            let key: String = category.name.contains(":") ? String(category.name[..<category.name.firstIndex(of: ":")!]) : "Other"
            if !categoriesDictionary.keys.contains(key) {
                categoriesDictionary[key] = []
            }
            var categoryName: String = category.name
            if categoryName.contains(":"){
                categoryName = String(categoryName[categoryName.index(after: categoryName.firstIndex(of: " ")!)...])
            }
            categoriesDictionary[key]?.append(categoryName)
        }
        return categoriesDictionary
    }
    
    func getCategory(by name: String) -> Category?{
        for category in categoriesArray{
            if category.name.contains(name){
                return category
            }
        }
        return nil
    }
    
    func getAnswers(for question: Question) -> [String]{
        var answers: [String] = []
        answers.append(question.correctAnswer)
        for wrongAnswers in question.incorrectAnswers{
            answers.append(wrongAnswers)
        }
        return answers.shuffled()
    }
}
