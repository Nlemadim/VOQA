//
//  QuestionDownloader.swift
//  VOQA
//
//  Created by Tony Nlemadim on 9/10/24.
//

import SwiftUI

class QuestionDownloader {
    let networkService = NetworkService()
    var config: UserConfig
    
    // Initialize QuestionDownloader with a UserConfig
    init(config: UserConfig) {
        self.config = config
    }
    
    // MARK: - Expose a public method to download quiz questions
    func downloadQuizQuestions(userId: String, quizTitle: String, narratorId: String, narrator: String, numberOfQuestions: Int?) async throws -> [Question] {
        // Prepare the request body for the API call
        let requestBody = QuestionRequestBody(
            userId: userId,
            quizTitle: quizTitle,
            narratorId: narratorId,
            narrator: narrator,
            numberOfQuestions: numberOfQuestions ?? 5
        )

        // Use live data by calling the fetchQuestions method
      //  let questions = try await fetchQuestions(requestBody: requestBody)
        
        //MARK: TEST DATA
        let mockQuestions = [question1, question2, question3, question1, question1]
        let questions = mockQuestions
        
        return questions
    }

    // MARK: - Private: Fetch Questions and manage audio download
    private func fetchQuestions(requestBody: QuestionRequestBody) async throws -> [Question] {
        print("Starting Download")
        let questions = try await networkService.fetchQuestions(requestBody: requestBody)

        let processedQuestions = questions

        return processedQuestions
       
    }
    
    private func narratorVoiceSelection(narrator: String) -> String {
        // Convert the string narrator to a VoiceSelector case
        guard let selectedVoice = VoiceSelector(rawValue: narrator) else {
            // Default to Gus if the narrator is not recognized
            return VoiceSelector.gus.voiceDesignation
        }
        
        return selectedVoice.voiceDesignation
    }
}


extension NetworkService {

    // MARK: - Fetch Questions V2 with request body
    func fetchQuestions(requestBody: QuestionRequestBody) async throws -> [Question] {
        print("Fetching questions V2 from URL: \(ConfigurationUrls.downloadVoqalizedQuestions)")

        // Prepare the URL and request
        guard let url = URL(string: ConfigurationUrls.downloadVoqalizedQuestions) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Encode the request body
        do {
            let bodyData = try JSONEncoder().encode(requestBody)
            request.httpBody = bodyData
            print("Request body successfully encoded.")
            print("Request Body: \(String(data: bodyData, encoding: .utf8) ?? "Unable to encode body")")
        } catch {
            print("Failed to encode request body: \(error)")
            throw error
        }

        // Make the network call
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)")
            }

            print("Received raw data size: \(data.count) bytes")

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON data: \(jsonString)")
            } else {
                print("Unable to convert data to string for debugging")
            }

            if data.count == 0 {
                print("Received empty data from the server.")
                throw URLError(.zeroByteResource)
            }

            print("Attempting to decode response data into Question models...")

            let questions = try JSONDecoder().decode([Question].self, from: data)

            print("Successfully decoded \(questions.count) questions V2.")
            // Optionally print the decoded data
            // print("Decoded questions: \(questions)")

            return questions

        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError.localizedDescription)")
            switch decodingError {
            case .dataCorrupted(let context):
                print("Data corrupted error: \(context.debugDescription)")
            case .keyNotFound(let key, let context):
                print("Key not found: \(key.stringValue), \(context.debugDescription)")
            case .typeMismatch(let type, let context):
                print("Type mismatch: \(type), \(context.debugDescription)")
            case .valueNotFound(let value, let context):
                print("Value not found: \(value), \(context.debugDescription)")
            default:
                print("Unknown decoding error.")
            }
            throw decodingError
        } catch {
            print("Network or other error: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Fetch Questions V2 with test data
    func testFetchQuestions(with testData: String) async throws -> [Question] {
        print("Testing fetchQuestions with provided JSON data.")

        // Convert the provided test data string into Data
        guard let data = testData.data(using: .utf8) else {
            throw URLError(.badURL)
        }

        print("Received raw data size: \(data.count) bytes")

        if data.count == 0 {
            print("Received empty data from the server.")
            throw URLError(.zeroByteResource)
        }

        print("Attempting to decode response data into Question models...")

        // Attempt to decode the provided data into Question models
        let questions = try JSONDecoder().decode([Question].self, from: data)

        print("Successfully decoded \(questions.count) questions V2.")
        // Optionally print the decoded data
        print("Decoded questions: \(questions)")

        return questions
    }
}


let jsonData = """

[
  {
    "quizId": "NCLEX-RN",
    "userId": "4A41E2FE-7F42-4A9E-BE4D-3DFE23EDAA58",
    "refId": "0492e72d-3f91-4ac6-8385-df0a83e33737",
    "content": "Which of the following best describes the reason for performing hand hygiene before donning gloves?",
    "mcOptions": {
      "A": false,
      "B": false,
      "C": false,
      "D": true
    },
    "selectedOption": "",
    "correction": "To reduce the risk of transmitting pathogens to the patient, highlighting the importance of hand hygiene in preventing infection transmission.",
    "numberOfPresentations": 0,
    "questionScript": "In the practice of maintaining sterility, which reason triumphs as the crucial purpose for hand hygiene before slipping into those protective gloves?",
    "repeatQuestionScript": "Let us revisit this important measure: Why is hand hygiene so vital before donning gloves?",
    "questionScriptAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/0492e72d-3f91-4ac6-8385-df0a83e33737_questionScript.mp3",
    "correctionAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/0492e72d-3f91-4ac6-8385-df0a83e33737_correction.mp3",
    "repeatQuestionAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/0492e72d-3f91-4ac6-8385-df0a83e33737_repeatQuestionScript.mp3",
    "coreTopic": "Safety and Infection Control",
    "questionStatus": {
      "knowledgeConfirmed": false,
      "isAnsweredCorrectly": false,
      "isAnswered": false
    }
  },
  {
    "quizId": "NCLEX-RN",
    "userId": "4A41E2FE-7F42-4A9E-BE4D-3DFE23EDAA58",
    "refId": "56fbd212-12c9-4fd4-aca5-42ad0dc0338c",
    "content": "Warfarin therapy requires monitoring of which blood test to assess therapeutic levels?",
    "mcOptions": {
      "A": false,
      "B": false,
      "C": false,
      "D": true
    },
    "selectedOption": "",
    "correction": "International normalized ratio (INR), which is the standardized measure for the effects of warfarin.",
    "numberOfPresentations": 0,
    "questionScript": "As the currents of medicines flow within, which blood test stands as the sentinel in gauging the impact of Warfarin therapy?",
    "repeatQuestionScript": "Here we go again: Which test ensures Warfarin's therapeutic guidance remains true?",
    "questionScriptAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/56fbd212-12c9-4fd4-aca5-42ad0dc0338c_questionScript.mp3",
    "correctionAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/56fbd212-12c9-4fd4-aca5-42ad0dc0338c_correction.mp3",
    "repeatQuestionAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/56fbd212-12c9-4fd4-aca5-42ad0dc0338c_repeatQuestionScript.mp3",
    "coreTopic": "Pharmacology and Medications",
    "questionStatus": {
      "knowledgeConfirmed": false,
      "isAnsweredCorrectly": false,
      "isAnswered": false
    }
  },
  {
    "quizId": "NCLEX-RN",
    "userId": "4A41E2FE-7F42-4A9E-BE4D-3DFE23EDAA58",
    "refId": "0e48e118-8391-45b0-be59-97633581553c",
    "content": "A nurse is teaching a patient about insulin administration. Which of the following should be included in the teaching regarding lipodystrophy?",
    "mcOptions": {
      "A": false,
      "B": true,
      "C": false,
      "D": false
    },
    "selectedOption": "",
    "correction": "Lipodystrophy is caused by repeated use of the same injection site and can result in poor insulin absorption.",
    "numberOfPresentations": 0,
    "questionScript": "When guiding a patient through the dance of insulin administration, what prudent advice prevents the shadows of lipodystrophy?",
    "repeatQuestionScript": "Consider again: Which counsel helps evade lipodystrophy in insulin use?",
    "questionScriptAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/0e48e118-8391-45b0-be59-97633581553c_questionScript.mp3",
    "correctionAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/0e48e118-8391-45b0-be59-97633581553c_correction.mp3",
    "repeatQuestionAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/0e48e118-8391-45b0-be59-97633581553c_repeatQuestionScript.mp3",
    "coreTopic": "Pharmacology and Medications",
    "questionStatus": {
      "knowledgeConfirmed": false,
      "isAnsweredCorrectly": false,
      "isAnswered": false
    }
  },
  {
    "quizId": "NCLEX-RN",
    "userId": "4A41E2FE-7F42-4A9E-BE4D-3DFE23EDAA58",
    "refId": "0a183a73-0f31-46ed-8e44-f30af7a50482",
    "content": "A 50-year-old male patient has no history of colon cancer in his family. According to current guidelines, at what age should he begin routine colorectal cancer screening?",
    "mcOptions": {
      "A": false,
      "B": false,
      "C": true,
      "D": false
    },
    "selectedOption": "",
    "correction": "45 years, reflecting the updated guidelines recommending earlier screenings for colorectal cancer.",
    "numberOfPresentations": 0,
    "questionScript": "In the stewardship of one’s health, what age does the wisdom of modern counsel ordain for the onset of routine colorectal screenings?",
    "repeatQuestionScript": "Reassess once more: At what age do we now advise initiating colorectal cancer screening?",
    "questionScriptAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/0a183a73-0f31-46ed-8e44-f30af7a50482_questionScript.mp3",
    "correctionAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/0a183a73-0f31-46ed-8e44-f30af7a50482_correction.mp3",
    "repeatQuestionAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/0a183a73-0f31-46ed-8e44-f30af7a50482_repeatQuestionScript.mp3",
    "coreTopic": "Health Promotion and Maintenance",
    "questionStatus": {
      "knowledgeConfirmed": false,
      "isAnsweredCorrectly": false,
      "isAnswered": false
    }
  },
  {
    "quizId": "NCLEX-RN",
    "userId": "4A41E2FE-7F42-4A9E-BE4D-3DFE23EDAA58",
    "refId": "f4a96364-77b6-4c9a-968b-cac31b41c962",
    "content": "What is the most appropriate action for a nurse to take when observing a sterile field has been contaminated?",
    "mcOptions": {
      "A": true,
      "B": false,
      "C": false,
      "D": false
    },
    "selectedOption": "",
    "correction": "Discard the contaminated items and establish a new sterile field, as maintaining sterility is crucial in preventing infection.",
    "numberOfPresentations": 0,
    "questionScript": "When the sacred space of sterility is breached, what is the precise course for a vigilant nurse to uphold the sanctity of infection control?",
    "repeatQuestionScript": "Let us ponder again: What step should follow once a sterile field is compromised?",
    "questionScriptAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/f4a96364-77b6-4c9a-968b-cac31b41c962_questionScript.mp3",
    "correctionAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/f4a96364-77b6-4c9a-968b-cac31b41c962_correction.mp3",
    "repeatQuestionAudioUrl": "https://storage.googleapis.com/buildship-ljnsun-us-central1/f4a96364-77b6-4c9a-968b-cac31b41c962_repeatQuestionScript.mp3",
    "coreTopic": "Safety and Infection Control",
    "questionStatus": {
      "knowledgeConfirmed": false,
      "isAnsweredCorrectly": false,
      "isAnswered": false
    }
  }
]

"""
let question1 = Question(
    refId: "ca007f3b-424c-45e8-8305-0408d576da03",
    content: "In the context of cellular respiration, what role does the electron transport chain play?",
    mcOptions: [
        "A: Breaks down glucose into pyruvate": false,
        "C: Generates ATP by oxidative phosphorylation": true,
        "B: Synthesizes glucose through photosynthesis": false,
        "D: Facilitates the synthesis of protein": false
    ],
    correction: "Your engagement with this question is appreciated, yet the precise answer is Option C: Generates ATP by oxidative phosphorylation. The electron transport chain is integral to cellular respiration, transferring electrons from NADH and FADH2 to oxygen, a process known as oxidative phosphorylation. This critical step generates a significant amount of ATP, the energy currency of the cell, supporting various cellular functions. This understanding underscores the importance of energy production mechanisms in biology.",
    numberOfPresentations: 2,
    questionScript: "Let's dive into the fascinating world of cellular respiration, a crucial process that cells use to break down glucose and produce the energy carrier, ATP. A key player in this process is the electron transport chain, known for its role in oxidative phosphorylation. *Here are your options:* Option A: Breaks down glucose into pyruvate, Option B: Synthesizes glucose through photosynthesis, Option C: Generates ATP by oxidative phosphorylation, Option D: Facilitates the synthesis of protein. Reflect on each option and choose wisely.",
    repeatQuestionScript: "In the context of cellular respiration, what role does the electron transport chain play? *Here are the options:* Option A: Breaks down glucose into pyruvate, Option B: Synthesizes glucose through photosynthesis, Option C: Generates ATP by oxidative phosphorylation, Option D: Facilitates the synthesis of protein.",
    questionScriptAudioURL: "https://storage.googleapis.com/buildship-ljnsun-us-central1/ca007f3b-424c-45e8-8305-0408d576da03_questionScript.mp3",
    correctionAudioURL: "https://storage.googleapis.com/buildship-ljnsun-us-central1/ca007f3b-424c-45e8-8305-0408d576da03_correction.mp3",
    repeatQuestionAudioURL: "https://storage.googleapis.com/buildship-ljnsun-us-central1/ca007f3b-424c-45e8-8305-0408d576da03_repeatQuestionScript.mp3",
    coreTopic: "Biological and Biochemical Foundations",
    quizId: "MCAT",
    userId: "rBkUyTtc2XXXcj43u53N",
    questionStatus: QuestionStatus(isAnswered: false, isAnsweredCorrectly: false, knowledgeConfirmed: false)
)

let question2 = question1
let question3 = question2

/***
 
 case refId
 case content
 case mcOptions
 case selectedOption
 case correction
 case numberOfPresentations
 case questionScript
 case repeatQuestionScript
 case questionScriptAudioURL
 case correctionAudioURL
 case repeatQuestionAudioURL
 case coreTopic
 case quizId
 case userId
 case questionStatus
 
 
 
 
 let question1 = Question(
     refId: "ca007f3b-424c-45e8-8305-0408d576da03",
     content: "In the context of cellular respiration, what role does the electron transport chain play?",
     mcOptions: [
         "A: Breaks down glucose into pyruvate": false,
         "C: Generates ATP by oxidative phosphorylation": true,
         "B: Synthesizes glucose through photosynthesis": false,
         "D: Facilitates the synthesis of protein": false
     ],
     correctOption: "B",
     selectedOption: nil,
     correction: "Your engagement with this question is appreciated, yet the precise answer is Option C: Generates ATP by oxidative phosphorylation. The electron transport chain is integral to cellular respiration, transferring electrons from NADH and FADH2 to oxygen, a process known as oxidative phosphorylation. This critical step generates a significant amount of ATP, the energy currency of the cell, supporting various cellular functions. This understanding underscores the importance of energy production mechanisms in biology.",
     isAnsweredOptional: nil,
     isAnsweredCorrectlyOptional: nil,
     numberOfPresentations: 2,
     questionScript: "Let's dive into the fascinating world of cellular respiration, a crucial process that cells use to break down glucose and produce the energy carrier, ATP. A key player in this process is the electron transport chain, known for its role in oxidative phosphorylation. *Here are your options:* Option A: Breaks down glucose into pyruvate, Option B: Synthesizes glucose through photosynthesis, Option C: Generates ATP by oxidative phosphorylation, Option D: Facilitates the synthesis of protein. Reflect on each option and choose wisely.",
     repeatQuestionScript: "In the context of cellular respiration, what role does the electron transport chain play? *Here are the options:* Option A: Breaks down glucose into pyruvate, Option B: Synthesizes glucose through photosynthesis, Option C: Generates ATP by oxidative phosphorylation, Option D: Facilitates the synthesis of protein.",
     questionScriptAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/ca007f3b-424c-45e8-8305-0408d576da03_questionScript.mp3",
     correctionAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/ca007f3b-424c-45e8-8305-0408d576da03_correction.mp3",
     repeatQuestionAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/ca007f3b-424c-45e8-8305-0408d576da03_repeatQuestionScript.mp3",
     coreTopic: "Biological and Biochemical Foundations",
     quizId: "MCAT",
     userId: "rBkUyTtc2XXXcj43u53N",
     questionStatus: QuestionStatus(isAnsweredCorrectly: false, isAnswered: false, knowledgeConfirmed: false)
 )
 
 let question2 = question1.copy(
     refId: "e533677c-dbc8-4ffd-9259-7f6ede2c01bc",
     content: "Which concept is central to understanding the flow of genetic information within a biological system?",
     mcOptions: [
         "C: Law of independent assortment": false,
         "B: Central dogma of molecular biology": true,
         "D: Law of segregation": false,
         "A: Theory of evolution by natural selection": false
     ],
     questionScriptAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/e533677c-dbc8-4ffd-9259-7f6ede2c01bc_questionScript.mp3",
     correctionAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/e533677c-dbc8-4ffd-9259-7f6ede2c01bc_correction.mp3",
     repeatQuestionAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/e533677c-dbc8-4ffd-9259-7f6ede2c01bc_repeatQuestionScript.mp3"
 )
 
 let question3 = question1.copy(
     refId: "a5723acc-3857-44db-91ba-cdf5b34e5915",
     content: "Which of the following enzymes is crucial for the unwinding of DNA during replication?",
     mcOptions: [
         "B: Ligase": false,
         "D: RNA polymerase": false,
         "A: Helicase": true,
         "C: DNA polymerase": false
     ],
     questionScriptAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/a5723acc-3857-44db-91ba-cdf5b34e5915_questionScript.mp3",
     correctionAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/a5723acc-3857-44db-91ba-cdf5b34e5915_correction.mp3",
     repeatQuestionAudioUrl: "https://storage.googleapis.com/buildship-ljnsun-us-central1/a5723acc-3857-44db-91ba-cdf5b34e5915_repeatQuestionScript.mp3"
 )
 
 
 
 
 */
