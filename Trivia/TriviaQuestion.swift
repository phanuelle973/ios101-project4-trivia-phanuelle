//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Phanuelle Manuel on 3/17/25.
//

import Foundation

struct TriviaQuestion: Decodable {
    let question: String
    let correctAnswer: String
    let choices: [String]
    let category: String

    enum CodingKeys: String, CodingKey {
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
        case category
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.question = try container.decode(String.self, forKey: .question)
        self.correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        self.category = try container.decode(String.self, forKey: .category)

        // Combine correct + incorrect answers and shuffle
        let incorrect = try container.decode([String].self, forKey: .incorrectAnswers)
        self.choices = ([correctAnswer] + incorrect).shuffled()
    }
}
