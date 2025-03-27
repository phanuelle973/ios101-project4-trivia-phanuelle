//
//  TriviaViewController.swift
//  Trivia
//
//  Created by Phanuelle Manuel on 3/13/25.
//

import UIKit

extension TriviaViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategoryID = categories[row].id
    }
}


class TriviaViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var questionCounterLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!

    let categories = [
        (id: 9, name: "General Knowledge"),
        (id: 11, name: "Film"),
        (id: 17, name: "Science & Nature"),
        (id: 18, name: "Computers"),
        (id: 21, name: "Sports"),
        (id: 23, name: "History")
    ]

    var selectedCategoryID = 9 // default
    var selectedDifficulty = "easy" // default


    @IBAction func difficultyChanged(_ sender: UISegmentedControl) {
        let options = ["easy", "medium", "hard"]
        selectedDifficulty = options[sender.selectedSegmentIndex]
    }

    
    
    // MARK: - Properties
    var questions: [TriviaQuestion] = []
    var currentQuestionIndex = 0
    var score = 0
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchQuestions()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self

    }
    
    // MARK: - Fetch Questions
    func fetchQuestions() {
        TriviaQuestionService.shared.fetchTriviaQuestions(
            category: selectedCategoryID,
            difficulty: selectedDifficulty
        ) { [weak self] questions, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showError(error)
                    return
                }

                self?.questions = questions ?? []
                self?.currentQuestionIndex = 0
                self?.score = 0
                self?.displayQuestion()
            }
        }
    }

    // MARK: - Display Question
    func displayQuestion() {
        guard currentQuestionIndex < questions.count else { return }
        let currentQuestion = questions[currentQuestionIndex]
        questionCounterLabel.text = "Question \(currentQuestionIndex + 1)/\(questions.count)"
        categoryLabel.text = currentQuestion.category
        questionLabel.text = currentQuestion.question

        let choices = currentQuestion.choices
        answerButton1.setTitle(choices[0], for: .normal)
        answerButton2.setTitle(choices[1], for: .normal)
        answerButton3.setTitle(choices[2], for: .normal)
        answerButton4.setTitle(choices[3], for: .normal)

        resetButtonColors()
    }

    
    
//    // MARK: - Setup Questions
//    func setupQuestions() {
//        questions = [
//            TriviaQuestion(
//                question: "What was the first weapon pack for 'PAYDAY'?",
//                choices: ["The Gage Weapon Pack #1", "The Overkill Pack", "The Gage Chivalry Pack", "The Gage Historical Pack"],
//                correctAnswer: "The Gage Weapon Pack #1",
//                category: "Entertainment: Video Games"
//            ),
//            TriviaQuestion(
//                question: "What year did World War II end?",
//                choices: ["1943", "1944", "1945", "1946"],
//                correctAnswer: "1945",
//                category: "History"
//            ),
//            TriviaQuestion(
//                question: "What is the capital of France?",
//                choices: ["Berlin", "Paris", "Rome", "Madrid"],
//                correctAnswer: "Paris",
//                category: "Geography"
//            )
//        ]
//    }
    
//    // MARK: - Display Question
//    func displayQuestion() {
//        let currentQuestion = questions[currentQuestionIndex]
//        questionCounterLabel.text = "Question \(currentQuestionIndex + 1)/\(questions.count)"
//        categoryLabel.text = currentQuestion.category
//        questionLabel.text = currentQuestion.question
//
//        answerButton1.setTitle(currentQuestion.choices[0], for: .normal)
//        answerButton2.setTitle(currentQuestion.choices[1], for: .normal)
//        answerButton3.setTitle(currentQuestion.choices[2], for: .normal)
//        answerButton4.setTitle(currentQuestion.choices[3], for: .normal)
//
//        resetButtonColors()
//    }

    // MARK: - Handle Answer Selection
    @IBAction func didTapAnswerButton(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]

        if sender.currentTitle == currentQuestion.correctAnswer {
            sender.backgroundColor = UIColor.green
            score += 1
        } else {
            sender.backgroundColor = UIColor.red
        }

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
        [answerButton1, answerButton2, answerButton3, answerButton4].forEach { button in
            button?.backgroundColor = UIColor.systemBlue
        }
    }

    // MARK: - Show Game Over Alert
    func showGameOver() {
        let alert = UIAlertController(title: "Game Over", message: "You got \(score)/\(questions.count) correct!", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.fetchQuestions()
        }))

        present(alert, animated: true)
    }

    // MARK: - Show Error
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    
    // MARK: - Restart Game
    func restartGame() {
        currentQuestionIndex = 0
        score = 0
        displayQuestion()
    }
}
