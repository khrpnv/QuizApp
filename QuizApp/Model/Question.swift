//
//  Question.swift
//  QuizApp
//
//  Created by Илья on 4/16/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Question{
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    var incorrectAnswers: [String]
}

extension Question{
    init?(json: JSON){
        guard let type = json["type"].string else { return nil }
        self.category = json["category"].stringValue
        self.type = type
        self.difficulty = json["difficulty"].stringValue
        self.question = json["question"].stringValue
        self.correctAnswer = json["correct_answer"].stringValue
        let incorrectAnswersArray = json["incorrect_answers"].arrayValue
        var incorrectAnswers: [String] = []
        for incorrectAnswer in incorrectAnswersArray{
            incorrectAnswers.append(incorrectAnswer.stringValue)
        }
        self.incorrectAnswers = incorrectAnswers
    }
}
