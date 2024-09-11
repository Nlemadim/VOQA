//
//  QuizList.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/23/24.
//

import Foundation

enum QuizList: String, CaseIterable {

    // Technology and Innovation
    case amazonWebServices = "Amazon Web Services"
    case kotlinProgramming = "Kotlin Programming Language"
    case swiftProgramming = "Swift Programming Language"
    case microsoftAzure = "Microsoft Azure"
    case privacyEngineeringPrinciples = "Privacy Engineering Principles"
    case ethicalHackingPrinciples = "Ethical Hacking Principles"
    case objectOrientedProgramming = "Object Oriented Programming"
    case linux = "Linux"
    case dataPrivacy = "Data Privacy"
    

    // Health and Medical Sciences
    case medicalCollegeAdmissionTest = "Medical College Admission Test"  // MCAT
    case nclexRN = "NCLEX-RN"  // NCLEX-RN
    case generalBiology = "General Biology"  // General Biology
    case humanAnatomy = "Human Anatomy"
    case generalChemistry = "General Chemistry"  // General Chemistry

    // History and Government
    case usConstitution = "US Constitution"  // US Constitution
    case americanHistory = "American History"  // American History
    case historyOfWorldWar1 = "History of World War 1"  // World War I History
    case historyOfWorldWar2 = "History of World War 2"  // World War II History

    // Business and Finance
    case realEstateLicensing = "Real Estate Licensing"  // Real Estate Licensing
    case certifiedPublicAccountantExam = "Certified Public Accountant Exam"
    case multistateBarExamination = "Multistate Bar Examination"
    
    // Sports and Recreation
    case mlbGreatestOfAllTime = "MLB Greatest of All Time"  // MLB G.O.A.T
    case nbaGreatestOfAllTime = "NBA Greatest of All Time"  // NBA G.O.A.T
    case worldCupHistory = "World Cup History"
    case f1RacingGreatestOfAllTime = "F1 Racing Greatest of All Time"
    case nascarGreatestOfAllTime = "Nascar Greatest of All Time"

    // Certifications and Professional Exams
    case ciscoCertifiedNetworkAssociateExam = "Cisco Certified Network Associate Exam"
    case comptiaCYSAPlus = "CompTIA CYSA+"
    case iappCertification = "IAPP Certification"
    case comptiaAPlus = "CompTIA A+"
    
    // Arts, Literature, and Humanities
    case englishLanguageArts = "English Language Arts"

    // Design and Architecture
    case uiUXDesign = "UI and UX Design"  // UI & UX Design

    // Education and Testing
    case act = "ACT"  // ACT
    case testOfEnglishAsForeignLanguage = "Test of English as a Foreign Language"  // TOEFL
    case sat = "SAT"
    case gre = "GRE"
    case lawSchoolAdmissionTest = "Law School Admission Test"  // Moved here
    case advancedPlacementExam = "Advanced Placement Exam"
    case engineerInTraining = "Engineer in Training"
  
}


/**
 
 
 Quiz Title: Kotlin Programming Language
 Quiz Title: Swift Programming Language
 Quiz Title: Data Privacy
 Quiz Title: UI and UX Design
 Quiz Title: Linux
 Quiz Title: Law School Admission Test
 Quiz Title: US Constitution
 Quiz Title: Certified Information Systems Auditor
 Quiz Title: Amazon Web Services
 Quiz Title: General Physics
 Quiz Title: Microsoft Azure
 Quiz Title: Ethical Hacking Principles
 Quiz Title: Privacy Engineering Principles
 Quiz Title: History of World War 1
 Quiz Title: History of World War 2
 Quiz Title: Human Anatomy
 Quiz Title: SAT
 Quiz Title: Real Estate Licensing
 Quiz Title: American History
 Quiz Title: CompTIA CYSA+
 Quiz Title: Medical College Admission Test
 Quiz Title: Certified Public Accountant Exam
 Quiz Title: Cisco Certified Network Associate Exam
 Quiz Title: CompTIA A+
 Quiz Title: General Chemistry
 Quiz Title: Test of English as a Foreign Language
 Quiz Title: Multistate Bar Examination
 Quiz Title: NCLEX-RN
 Quiz Title: Advanced Placement Exam
 Quiz Title: General Physics
 Quiz Title: General Biology
 Quiz Title: Engineer in Training
 Quiz Title: English Language Arts
 Quiz Title: GRE
 Quiz Title: ACT
 Quiz Title: World Cup History
 Quiz Title: MLB Greatest of All Time
 Quiz Title: NBA Greatest of All Time
 Quiz Title: F1 Racing Greatest of All Time
 Quiz Title: Nascar Greatest of All Time
 Quiz Title: IAPP Certification
 Quiz Title: Object Oriented Programming
 
 
 Mapped Quiz: Medical College Admission Test -> Medical College Admission Test in Medical Mastery
 Mapped Quiz: NCLEX-RN -> NCLEX-RN in Medical Mastery
 Mapped Quiz: General Biology -> General Biology in Medical Mastery
 Mapped Quiz: Human Anatomy -> Human Anatomy in Medical Mastery
 Mapped Quiz: General Chemistry -> General Chemistry in Medical Mastery
 Mapped Quiz: US Constitution -> US Constitution in History and Government Challenges
 Mapped Quiz: American History -> American History in History and Government Challenges
 Mapped Quiz: History of World War 1 -> History of World War 1 in History and Government Challenges
 Mapped Quiz: History of World War 2 -> History of World War 2 in History and Government Challenges
 Mapped Quiz: UI and UX Design -> UI and UX Design in Creative Design and Architectural Wonders
 Mapped Quiz: ACT -> ACT in Academic Challenges and Standardized Tests
 Mapped Quiz: Test of English as a Foreign Language -> Test of English as a Foreign Language in Academic Challenges and Standardized Tests
 Mapped Quiz: SAT -> SAT in Academic Challenges and Standardized Tests
 Mapped Quiz: GRE -> GRE in Academic Challenges and Standardized Tests
 Mapped Quiz: Law School Admission Test -> Law School Admission Test in Academic Challenges and Standardized Tests
 Mapped Quiz: Advanced Placement Exam -> Advanced Placement Exam in Academic Challenges and Standardized Tests
 Mapped Quiz: Engineer in Training -> Engineer in Training in Academic Challenges and Standardized Tests
 Mapped Quiz: Cisco Certified Network Associate Exam -> Cisco Certified Network Associate Exam in Certifications and Career Advancement
 Mapped Quiz: CompTIA CYSA+ -> CompTIA CYSA+ in Certifications and Career Advancement
 Mapped Quiz: IAPP Certification -> IAPP Certification in Certifications and Career Advancement
 Mapped Quiz: CompTIA A+ -> CompTIA A+ in Certifications and Career Advancement
 Mapped Quiz: Amazon Web Services -> Amazon Web Services in Tech Trailblazers
 Mapped Quiz: Kotlin Programming Language -> Kotlin Programming Language in Tech Trailblazers
 Mapped Quiz: Swift Programming Language -> Swift Programming Language in Tech Trailblazers
 Mapped Quiz: Microsoft Azure -> Microsoft Azure in Tech Trailblazers
 Mapped Quiz: Privacy Engineering Principles -> Privacy Engineering Principles in Tech Trailblazers
 Mapped Quiz: Ethical Hacking Principles -> Ethical Hacking Principles in Tech Trailblazers
 Mapped Quiz: Object Oriented Programming -> Object Oriented Programming in Tech Trailblazers
 Mapped Quiz: Linux -> Linux in Tech Trailblazers
 Mapped Quiz: Data Privacy -> Data Privacy in Tech Trailblazers
 Mapped Quiz: English Language Arts -> English Language Arts in Cultural Odyssey
 Mapped Quiz: Real Estate Licensing -> Real Estate Licensing in Business and Financial Acumen
 Mapped Quiz: Certified Public Accountant Exam -> Certified Public Accountant Exam in Business and Financial Acumen
 Mapped Quiz: Multistate Bar Examination -> Multistate Bar Examination in Business and Financial Acumen
 Mapped Quiz: MLB Greatest of All Time -> MLB Greatest of All Time in Sports Legends and Trivia
 Mapped Quiz: NBA Greatest of All Time -> NBA Greatest of All Time in Sports Legends and Trivia
 Mapped Quiz: World Cup History -> World Cup History in Sports Legends and Trivia
 Mapped Quiz: F1 Racing Greatest of All Time -> F1 Racing Greatest of All Time in Sports Legends and Trivia
 Mapped Quiz: Nascar Greatest of All Time -> Nascar Greatest of All Time in Sports Legends and Trivia
 
 
 
 
 */
