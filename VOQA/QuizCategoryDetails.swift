//
//  QuizCategoryDetails.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/23/24.
//

import Foundation

enum CatalogueDetails: Hashable {
    case artsAndHumanities(title: String = "Arts and Humanities", description: String = "Explore the rich history and diverse cultural expressions of humanity.")
    case collegeAdmissionsExams(title: String = "Most Popular College Admission Exams", description: String = "Prepare for the most important college admission exams with our comprehensive quizzes.")
    case professionalCertifications(title: String = "Most Popular Professional Certifications and Exams", description: String = "Enhance your career with top certifications and professional exams.")
    case techAndInnovation(title: String = "Innovators' Hub (Tech and Innovation)", description: String = "Dive into the world of technology and innovation with these quizzes.")
    case topPicks(title: String = "Top Picks", description: String = "Our top selections of quizzes across various categories.")
    case others(title: String = "Others", description: String = "Additional quizzes not categorized under the main groups.")
    
    var details: (title: String, description: String) {
        switch self {
        case .artsAndHumanities(let title, let description),
             .collegeAdmissionsExams(let title, let description),
             .professionalCertifications(let title, let description),
             .techAndInnovation(let title, let description),
             .topPicks(let title, let description),
             .others(let title, let description):
            return (title, description)
        }
    }
    
    static func category(for quiz: QuizList) -> CatalogueDetails? {
        switch quiz {
        case .historyOfWorldWar1, .historyOfWorldWar2, .usConstitution, .americanHistory:
            return .artsAndHumanities()
        case .sat, .gre, .act, .lawSchoolAdmissionTest, .medicalCollegeAdmissionTest:
            return .collegeAdmissionsExams()
        case .certifiedPublicAccountantExam, .comptiaCYSAPlus, .ciscoCertifiedNetworkAssociateExam, .comptiaAPlus, .certifiedInformationSystemsAuditor:
            return .professionalCertifications()
        case .kotlinProgramming, .swiftProgramming, .amazonWebServices, .microsoftAzure, .privacyEngineeringPrinciples:
            return .techAndInnovation()
        case .worldCupHistory, .mlbGreatestOfAllTime, .nbaGreatestOfAllTime, .f1RacingGreatestOfAllTime, .nascarGreatestOfAllTime:
            return .others()
        case .realEstateLicensing, .generalPhysics, .generalBiology, .generalChemistry, .dataPrivacy:
            return .topPicks()
        default:
            return nil
        }
    }
}
