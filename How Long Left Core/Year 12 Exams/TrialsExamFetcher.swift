//
//  TrialsExamFetcher.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 29/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
/*
class TrialsExamFetcher {
    
    func getTrialsExams() -> [Exam] {
        
        // Creates an array of exams.
        var exams = [Exam]()
    
        let subjects = HLLDefaults.magdalene.hscSubjects
        
        for subject in subjects {
            
            switch subject {
                
            case .englishStandard:
   
                exams.append(Exam(subject: .englishStandard, date: TrialsExamDate(.monday1, session: .morning, durationHours: 1.5), description: "Exam 1"))
                
                exams.append(Exam(subject: .englishStandard, date: TrialsExamDate(.tuesday1, session: .morning, durationHours: 2), description: "Exam 2"))
                
            case .englishAdvanced:
                
                exams.append(Exam(subject: .englishAdvanced, date: TrialsExamDate(.monday1, session: .morning, durationHours: 1.5), description: "Exam 1"))
                
                exams.append(Exam(subject: .englishAdvanced, date: TrialsExamDate(.tuesday1, session: .morning, durationHours: 2), description: "Exam 2"))
                
            case .englishStudies:
                
                exams.append(Exam(subject: .englishStudies, date: TrialsExamDate(.monday1, session: .morning, durationHours: 2.5)))
                
            case .music1:
                
                exams.append(Exam(subject: .music1, date: TrialsExamDate(.monday1, session: .afternoon, durationHours: 1)))
                
            case .anicentHistory:
                
                exams.append(Exam(subject: .anicentHistory, date: TrialsExamDate(.friday1, session: .afternoon, durationHours: 3)))
                
            case .economics:
                exams.append(Exam(subject: .economics, date: TrialsExamDate(.monday3, session: .afternoon, durationHours: 3)))
                
            case .visualArts:
                
                exams.append(Exam(subject: .visualArts, date: TrialsExamDate(.wednesday1, session: .morning, durationHours: 1.5)))
                
            case .VETRetail:
                
                exams.append(Exam(subject: .VETRetail, date: TrialsExamDate(.monday1, session: .afternoon, durationHours: 2)))
                
            case .DAndT:
                
                exams.append(Exam(subject: .DAndT, date: TrialsExamDate(.tuesday1, session: .afternoon, durationHours: 1.5)))
                
            case .legalStudies:
                
                exams.append(Exam(subject: .legalStudies, date: TrialsExamDate(.wednesday1, session: .morning, durationHours: 3)))
                
            case .timberAndFurniture:
                
                exams.append(Exam(subject: .timberAndFurniture, date: TrialsExamDate(.wednesday1, session: .afternoon, durationHours: 1.5)))
                
            case .textilesAndDesign:
                
                exams.append(Exam(subject: .textilesAndDesign, date: TrialsExamDate(.wednesday1, session: .afternoon, durationHours: 1.5)))
                
            case .mathematicsStandard2:
                
                exams.append(Exam(subject: .mathematicsStandard2, date: TrialsExamDate(.thursday1, session: .morning, durationHours: 2.5)))
                
            case .mathematicsAdvanced:
                
                exams.append(Exam(subject: .mathematicsAdvanced, date: TrialsExamDate(.thursday1, session: .morning, durationHours: 3)))
                
            case .mathematicsExtension2:
                
                exams.append(Exam(subject: .mathematicsExtension2, date: TrialsExamDate(.thursday1, session: .morning, durationHours: 3)))
                
            case .modernHistory:
                
                exams.append(Exam(subject: .modernHistory, date: TrialsExamDate(.thursday1, session: .afternoon, durationHours: 3)))
                
            case .VETHospitality:
                
                exams.append(Exam(subject: .VETHospitality, date: TrialsExamDate(.thursday1, session: .afternoon, durationHours: 2)))
                
            case .chemistry:
                
                exams.append(Exam(subject: .chemistry, date: TrialsExamDate(.friday1, session: .morning, durationHours: 3)))
                
            case .investigatingScience:
                
                exams.append(Exam(subject: .investigatingScience, date: TrialsExamDate(.friday1, session: .morning, durationHours: 2)))
                
            case .software:
                
                exams.append(Exam(subject: .software, date: TrialsExamDate(.friday1, session: .afternoon, durationHours: 3)))
                
            case .SOR1:
                
                exams.append(Exam(subject: .SOR1, date: TrialsExamDate(.monday2, session: .morning, durationHours: 1.5)))
                
            case .SOR2:
                
                exams.append(Exam(subject: .SOR2, date: TrialsExamDate(.monday2, session: .morning, durationHours: 3)))
                
            case .CAFS:
                
                exams.append(Exam(subject: .CAFS, date: TrialsExamDate(.monday2, session: .afternoon, durationHours: 3)))
                
            case .physics:
                
                exams.append(Exam(subject: .physics, date: TrialsExamDate(.tuesday2, session: .morning, durationHours: 3)))
                
            case .societyAndCulture:
                
                exams.append(Exam(subject: .societyAndCulture, date: TrialsExamDate(.tuesday2, session: .morning, durationHours: 3)))
                
            case .businessStudies:
                
                exams.append(Exam(subject: .businessStudies, date: TrialsExamDate(.tuesday2, session: .afternoon, durationHours: 3)))
                
            case .PDHPE:
                
                exams.append(Exam(subject: .PDHPE, date: TrialsExamDate(.wednesday2, session: .morning, durationHours: 3)))
                
            case .foodTechnology:
                
                exams.append(Exam(subject: .foodTechnology, date: TrialsExamDate(.wednesday2, session: .afternoon, durationHours: 3)))
                
            case .biology:
                
                exams.append(Exam(subject: .biology, date: TrialsExamDate(.thursday2, session: .morning, durationHours: 3)))
                
            case .englishExtension1:
                
                exams.append(Exam(subject: .englishExtension1, date: TrialsExamDate(.thursday2, session: .afternoon, durationHours: 2)))
                
            case .IPT:
                
                exams.append(Exam(subject: .IPT, date: TrialsExamDate(.thursday2, session: .afternoon, durationHours: 3)))
                
            case .geography:
                
                exams.append(Exam(subject: .geography, date: TrialsExamDate(.friday2, session: .morning, durationHours: 3)))
                
            case .VETConstruction:
                
                exams.append(Exam(subject: .VETConstruction, date: TrialsExamDate(.friday2, session: .morning, durationHours: 3)))
                
            case .mathematicsExtension1:
                
                exams.append(Exam(subject: .mathematicsExtension2, date: TrialsExamDate(.friday2, session: .afternoon, durationHours: 2)))
                
            case .drama:
                
                exams.append(Exam(subject: .drama, date: TrialsExamDate(.friday2, session: .afternoon, durationHours: 1.5)))
                
            case .VETBusinessServices:
                
                exams.append(Exam(subject: .VETBusinessServices, date: TrialsExamDate(.monday3, session: .morning, durationHours: 2)))
                
            case .historyExtension:
                
                exams.append(Exam(subject: .historyExtension, date: TrialsExamDate(.monday3, session: .afternoon, durationHours: 2)))
                
            }
            
        }
        
        return exams
        
    }
    
}
*/
