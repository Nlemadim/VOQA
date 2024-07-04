//
//  NetworkService+Test+Ext.swift
//  VOQA
//
//  Created by Tony Nlemadim on 6/24/24.
//

import Foundation

extension NetworkService {
    /// Fetch topics based on the provided context from mock JSON data
    /// - Parameter context: The context to filter topics
    /// - Returns: An array of topics as dictionaries
    func fetchMockTopics(context: String) async throws -> [[String: Any]] {
        // Sample mock JSON data
        let mockJson = """
        {
            "topics": [
                {
                    "id": "c1e4b5ff-6e2a-4f1c-9d9d-1a1b6f6b7c8d",
                    "title": "Sample Topic 1",
                    "category": 0,
                    "learningIndex": 1,
                    "presentations": 5,
                    "progress": 0.8
                },
                {
                    "id": "c1e4b5ff-6e2a-4f1c-9d9d-1a1b6f6b7c9e",
                    "title": "Sample Topic 2",
                    "category": 1,
                    "learningIndex": 2,
                    "presentations": 3,
                    "progress": 0.6
                }
            ]
        }
        """
        
        let data = Data(mockJson.utf8)
        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [[String: Any]]]
        
        guard let topics = jsonResponse?["topics"] else {
            throw NetworkError(message: "Key 'topics' not found in response.")
        }
        
        return topics
    }
    
    /// Fetch question data for the provided parameters from mock JSON data
    /// - Parameters:
    ///   - examName: The name of the exam
    ///   - topics: A list of topics
    ///   - number: The number of questions
    /// - Returns: An array of `Question` objects
    func fetchMockQuestionData(examName: String, topics: [String], number: Int) async throws -> [Question] {
        // Sample mock JSON data
        let mockJson = """
        [
            {
                "id": "c1e4b5ff-6e2a-4f1c-9d9d-1a1b6f6b7c8d",
                "topicId": "c1e4b5ff-6e2a-4f1c-9d9d-1a1b6f6b7c8d",
                "content": "Sample Question 1",
                "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
                "correctOption": "Option 1",
                "selectedOption": "",
                "isAnswered": false,
                "isAnsweredCorrectly": false,
                "numberOfPresentations": 0,
                "ratings": 0,
                "numberOfRatings": 0,
                "audioScript": "Sample audio script 1",
                "audioUrl": "http://example.com/audio1",
                "replayQuestionAudioScript": "Replay script 1",
                "replayOptionAudioScript": "Replay option script 1",
                "status": "newQuestion"
            },
            {
                "id": "c1e4b5ff-6e2a-4f1c-9d9d-1a1b6f6b7c9e",
                "topicId": "c1e4b5ff-6e2a-4f1c-9d9d-1a1b6f6b7c9e",
                "content": "Sample Question 2",
                "options": ["Option A", "Option B", "Option C", "Option D"],
                "correctOption": "Option B",
                "selectedOption": "",
                "isAnswered": false,
                "isAnsweredCorrectly": false,
                "numberOfPresentations": 0,
                "ratings": 0,
                "numberOfRatings": 0,
                "audioScript": "Sample audio script 2",
                "audioUrl": "http://example.com/audio2",
                "replayQuestionAudioScript": "Replay script 2",
                "replayOptionAudioScript": "Replay option script 2",
                "status": "newQuestion"
            }
        ]
        """
        
        let data = Data(mockJson.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        let questions = try decoder.decode([Question].self, from: data)
        
        return questions
    }
}


func generateMockJSON() -> String {
    let uuid1 = UUID().uuidString
    let uuid2 = UUID().uuidString
    let uuid3 = UUID().uuidString
    let uuid4 = UUID().uuidString
    let uuid5 = UUID().uuidString
    let uuid6 = UUID().uuidString

    let jsonData = """
    {
      "topCollectionQuizzes": [
        {
          "id": "\(uuid1)",
          "title": "General Knowledge",
          "titleImage": "general_knowledge.png",
          "summaryDesc": "Test your general knowledge with this quiz package.",
          "themeColors": [255, 0, 0],
          "rating": 4,
          "numberOfRatings": 100,
          "edition": "basic",
          "curator": "Quiz Master",
          "users": 1000,
          "topics": []
        },
        {
          "id": "\(uuid2)",
          "title": "Science Quiz",
          "titleImage": "science_quiz.png",
          "summaryDesc": "Explore the wonders of science.",
          "themeColors": [0, 255, 0],
          "rating": 5,
          "numberOfRatings": 150,
          "edition": "advanced",
          "curator": "Science Expert",
          "users": 500,
          "topics": []
        },
        {
          "id": "\(uuid3)",
          "title": "History Quiz",
          "titleImage": "history_quiz.png",
          "summaryDesc": "Dive into the past with our history quiz.",
          "themeColors": [0, 0, 255],
          "rating": 3,
          "numberOfRatings": 75,
          "edition": "basic",
          "curator": "History Buff",
          "users": 300,
          "topics": []
        }
      ],
      "nowPlaying": {
        "id": "\(uuid4)",
        "quizTitle": "Now Playing Quiz",
        "titleImage": "now_playing.png",
        "shortTitle": "NPQ",
        "firstStarted": "2024-06-24T00:00:00Z",
        "completions": 10,
        "userHighScore": 95,
        "ratings": 200,
        "currentQuizTopics": [
          {
            "id": "\(uuid5)",
            "name": "Topic 1",
            "description": "Description of Topic 1"
          },
          {
            "id": "\(uuid6)",
            "name": "Topic 2",
            "description": "Description of Topic 2"
          }
        ]
      },
      "currentItem": 1,
      "backgroundImage": "background.png",
      "galleryItems": [
        {
          "title": "Featured Quizzes",
          "subtitle": "Top quizzes of the week",
          "quizzes": [
            {
              "id": "\(uuid1)",
              "title": "General Knowledge",
              "titleImage": "general_knowledge.png",
              "summaryDesc": "Test your general knowledge with this quiz package.",
              "themeColors": [255, 0, 0],
              "rating": 4,
              "numberOfRatings": 100,
              "edition": "basic",
              "curator": "Quiz Master",
              "users": 1000,
              "topics": []
            }
          ]
        }
      ]
    }
    """
    
    return jsonData
}
