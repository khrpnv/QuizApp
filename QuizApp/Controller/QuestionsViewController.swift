//
//  QuestionsViewController.swift
//  QuizApp
//
//  Created by Илья on 4/16/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import UIKit
import WebKit

class QuestionsViewController: UIViewController {
    
    var categoryName: String?
    private var category: Category?
    private var questions: [Question] = []
    private var questionIndex: Int = 0
    private var answers: [String] = []
    private var cellClicked: Bool = false
    private var result: Int = 0
    
    @IBOutlet private weak var ibQuestionLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var ibActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        ibQuestionLabel.adjustsFontSizeToFitWidth = true
        self.title = categoryName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ibActivityIndicator.startAnimating()
        questions = []
        if let nameOfCategory = categoryName{
            category = DataManager.instance.getCategory(by: nameOfCategory)
        }
        guard let selectedCategory = category else { return }
        DataManager.instance.loadQuestions(for: selectedCategory)
        NotificationCenter.default.addObserver(self, selector: #selector(questionsWereLoaded), name: .QuestionsWereLoaded, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .QuestionsWereLoaded, object: nil)
    }
    
    @IBAction private func nextQuestionButtonPressed(_ sender: Any) {
        showQuestion()
    }
    
    private func showQuestion(){
        let question = self.questions[self.questionIndex]
        self.answers = DataManager.instance.getAnswers(for: question)
        self.ibQuestionLabel.attributedText = question.question.htmlAttributedStringForQuestion
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        cellClicked = false
        questionIndex+=1
        if questionIndex == questions.count{
            let alertVC = UIAlertController(title: "Result", message: "You have finished this test. You have earned \(self.result) points of \(questions.count). Try to solve some other tests.", preferredStyle: .alert)
            let backButton = UIAlertAction(title: "Back", style: .default) { [weak self](action) in
                self?.navigationController?.popViewController(animated: true)
            }
            alertVC.addAction(backButton)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
}

//Mark: - Notifications handler
extension QuestionsViewController{
    @objc func questionsWereLoaded(){
        ibActivityIndicator.stopAnimating()
        self.questions = DataManager.instance.questions.shuffled()
        showQuestion()
    }
}

//MARK: - Table view settings
extension QuestionsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.answers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeight = tableView.frame.height/CGFloat(self.answers.count)
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionAnswer", for: indexPath)
        cell.textLabel?.attributedText = answers[indexPath.row].htmlAttributedStringForAnswer
        cell.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cellClicked { return }
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let question = questions[questionIndex - 1]
        if cell.textLabel?.text?.htmlAttributedStringForAnswer == question.correctAnswer.htmlAttributedStringForAnswer{
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            self.result+=1
        } else {
            cell.backgroundColor = .red
        }
        cellClicked = true
    }
    
    
}
