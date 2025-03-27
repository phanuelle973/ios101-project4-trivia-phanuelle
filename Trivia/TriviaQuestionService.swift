//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Phanuelle Manuel on 3/26/25.
//

import Foundation

class TriviaQuestionService {
    static let shared = TriviaQuestionService()

    private let apiURL = "https://opentdb.com/api.php?amount=5&category=21&difficulty=medium&type=multiple"
    // used Postman to test the Open Trivia Database API request and preview the JSON structure

    struct APIResponse: Decodable {
        let results: [TriviaQuestion]
    }

    func fetchTriviaQuestions(category: Int, difficulty: String, completion: @escaping ([TriviaQuestion]?, Error?) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=5&type=multiple&category=\(category)&difficulty=\(difficulty)"
        guard let url = URL(string: apiURL) else {
            completion(nil, NSError(domain: "Invalid URL", code: -1))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "No Data", code: -1))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(decoded.results, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
