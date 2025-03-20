//
//  TriviaViewController.swift
//  Trivia
//
//  Created by Phanuelle Manuel on 3/13/25.
//

import UIKit

class TriviaViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var questionCounterLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    
    // MARK: - Properties
    var questions: [TriviaQuestion] = []
    var currentQuestionIndex = 0
    var score = 0
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuestions()
        displayQuestion()
    }
    
    // MARK: - Setup Questions
    func setupQuestions() {
        questions = [
            TriviaQuestion(
                question: "What was the first weapon pack for 'PAYDAY'?",
                choices: ["The Gage Weapon Pack #1", "The Overkill Pack", "The Gage Chivalry Pack", "The Gage Historical Pack"],
                correctAnswer: "The Gage Weapon Pack #1",
                category: "Entertainment: Video Games"
            ),
            TriviaQuestion(
                question: "What year did World War II end?",
                choices: ["1943", "1944", "1945", "1946"],
                correctAnswer: "1945",
                category: "History"
            ),
            TriviaQuestion(
                question: "What is the capital of France?",
                choices: ["Berlin", "Paris", "Rome", "Madrid"],
                correctAnswer: "Paris",
                category: "Geography"
            )
        ]
    }
    
    // MARK: - Display Question
    func displayQuestion() {
        let currentQuestion = questions[currentQuestionIndex]
        questionCounterLabel.text = "Question \(currentQuestionIndex + 1)/\(questions.count)"
        categoryLabel.text = currentQuestion.category
        questionLabel.text = currentQuestion.question

        answerButton1.setTitle(currentQuestion.choices[0], for: .normal)
        answerButton2.setTitle(currentQuestion.choices[1], for: .normal)
        answerButton3.setTitle(currentQuestion.choices[2], for: .normal)
        answerButton4.setTitle(currentQuestion.choices[3], for: .normal)

        resetButtonColors()
    }

    // MARK: - Handle Answer Selection
    @IBAction func didTapAnswerButton(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        
        if sender.currentTitle == currentQuestion.correctAnswer {
            sender.backgroundColor = UIColor.green
            score += 1
        } else {
            sender.backgroundColor = UIColor.red
        }

        // Wait briefly before moving to the next question
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.nextQuestion()
        }
    }
    
    // MARK: - Move to Next Question
    func nextQuestion() {
        currentQuestionIndex += 1
        
        if currentQuestionIndex < questions.count {
            displayQuestion()
        } else {
            showGameOver()
        }
    }
    
    // MARK: - Reset Button Colors
    func resetButtonColors() {
        answerButton1.backgroundColor = UIColor.systemBlue
        answerButton2.backgroundColor = UIColor.systemBlue
        answerButton3.backgroundColor = UIColor.systemBlue
        answerButton4.backgroundColor = UIColor.systemBlue
    }
    
    // MARK: - Show Game Over Alert
    func showGameOver() {
        let alert = UIAlertController(title: "Game Over", message: "You got \(score)/\(questions.count) correct!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.restartGame()
        }))
        
        present(alert, animated: true)
    }
    
    // MARK: - Restart Game
    func restartGame() {
        currentQuestionIndex = 0
        score = 0
        displayQuestion()
    }
}
