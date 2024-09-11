//
//  QuizCategoryDetails.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/23/24.
//

import Foundation

enum CatalogueDetails: Hashable {

    // Technology and Innovation
    case technologyAndInnovation(title: String = "Tech Trailblazers",
        description: String = "Test your knowledge in tech with quizzes on programming, cloud computing, and more. Perfect for tech enthusiasts looking to push their skills further.")
    
    // Health and Medical Sciences
    case healthAndMedical(title: String = "Medical Mastery",
        description: String = "Challenge yourself with quizzes in biology, anatomy, and professional medical exams. Perfect for medical students or health professionals.")
    
    // History and Government
    case historyAndGovernment(title: String = "History and Government Challenges",
        description: String = "From historical events to political systems, test your knowledge on the world's most important moments and movements.")
    
    // Business and Finance
    case businessAndFinance(title: String = "Business and Financial Acumen",
        description: String = "Sharpen your business sense with quizzes on finance, law, and real estate. Ideal for professionals or business enthusiasts.")
    
    // Sports and Recreation
    case sportsAndRecreation(title: String = "Sports Legends and Trivia",
        description: String = "Think you know your sports? Test your trivia skills on the greatest players, teams, and events in sports history.")
    
    // Certifications and Professional Exams
    case certificationsAndExams(title: String = "Certifications and Career Advancement",
        description: String = "Prepare for professional certifications with these quizzes designed to challenge your knowledge in IT, security, and other fields.")
    
    // Education and Testing
    case educationAndTesting(title: String = "Academic Challenges and Standardized Tests",
        description: String = "Prepare for standardized tests and core academic subjects. Ideal for students gearing up for admissions exams or academic challenges.")
    
    // Top Picks
    case topPicks(title: String = "Top Picks",
        description: String = "Discover the most popular and highly recommended quizzes. From tech to biology, these are the best of the best.")
    
    // Returning the details for the selected case
    var details: (title: String, description: String) {
        switch self {
        case .technologyAndInnovation(let title, let description),
             .healthAndMedical(let title, let description),
             .historyAndGovernment(let title, let description),
             .businessAndFinance(let title, let description),
             .sportsAndRecreation(let title, let description),
             .certificationsAndExams(let title, let description),
             .educationAndTesting(let title, let description),
             .topPicks(let title, let description):
            return (title, description)
        }
    }

    // Mapping quizzes to their respective categories
    static func category(for quiz: QuizList) -> CatalogueDetails? {
        switch quiz {

        // Technology and Innovation
        case .kotlinProgramming,
             .microsoftAzure, .privacyEngineeringPrinciples,
             .ethicalHackingPrinciples, .objectOrientedProgramming, .linux, .dataPrivacy, .uiUXDesign:
            return .technologyAndInnovation()
        
        // Health and Medical Sciences
        case .medicalCollegeAdmissionTest, .nclexRN,
             .humanAnatomy, .generalChemistry:
            return .healthAndMedical()
        
        // History and Government
        case .usConstitution, .americanHistory,
             .historyOfWorldWar1, .historyOfWorldWar2:
            return .historyAndGovernment()

        // Business and Finance
        case .realEstateLicensing, .certifiedPublicAccountantExam,
             .multistateBarExamination:
            return .businessAndFinance()
        
        // Sports and Recreation
        case .mlbGreatestOfAllTime, .nbaGreatestOfAllTime, .worldCupHistory,
             .f1RacingGreatestOfAllTime, .nascarGreatestOfAllTime:
            return .sportsAndRecreation()

        // Certifications and Professional Exams
        case .ciscoCertifiedNetworkAssociateExam,
             .comptiaCYSAPlus,
             .iappCertification:
            return .certificationsAndExams()

        // Education and Testing
        case .act, .testOfEnglishAsForeignLanguage, .gre, .englishLanguageArts,
             .lawSchoolAdmissionTest, .engineerInTraining:
            return .educationAndTesting()

        // Top Picks
        case .sat, .amazonWebServices, .advancedPlacementExam, .comptiaAPlus, .generalBiology, .swiftProgramming:
            return .topPicks()
        }
    }
}
