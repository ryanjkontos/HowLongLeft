//
//  Subject.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 29/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

enum Subject: Int, CaseIterable {
    
    case englishStandard
    case englishAdvanced
    case englishStudies
    case music1
    case anicentHistory
    case economics
    case visualArts
    case VETRetail
    case DAndT
    case legalStudies
    case timberAndFurniture
    case textilesAndDesign
    case mathematicsStandard2
    case mathematicsAdvanced
    case mathematicsExtension2
    case modernHistory
    case VETHospitality
    case chemistry
    case investigatingScience
    case software
    case SOR1
    case SOR2
    case CAFS
    case physics
    case societyAndCulture
    case businessStudies
    case PDHPE
    case foodTechnology
    case biology
    case englishExtension1
    case IPT
    case geography
    case VETConstruction
    case mathematicsExtension1
    case drama
    case VETBusinessServices
    case historyExtension
    
    
    static var asArray: [Subject] {return self.allCases}

    var subjectName: String {
        
        get {
            
            switch self {
                
            case .englishStandard:
                return "English Standard"
            case .englishAdvanced:
                return "English Advanced"
            case .englishStudies:
                return "English Studies"
            case .music1:
                return "Music 1"
            case .anicentHistory:
                return "Ancient History"
            case .economics:
                return "Ecnomics"
            case .visualArts:
                return "Visual Arts"
            case .VETRetail:
                return "Retail"
            case .DAndT:
                return "D&T"
            case .legalStudies:
                return "Legal Studies"
            case .timberAndFurniture:
                return "Timber and Furniture"
            case .mathematicsStandard2:
                return "Maths Standard 2"
            case .mathematicsAdvanced:
                return "Advanced Maths"
            case .mathematicsExtension2:
                return "Maths Extension 2"
            case .modernHistory:
                return "Modern History"
            case .VETHospitality:
                return "Hospitality"
            case .chemistry:
                return "Chemistry"
            case .investigatingScience:
                return "Investigating Science"
            case .software:
                return "SDD"
            case .SOR1:
                return "Studies of Religion 1"
            case .SOR2:
                return "Studies of Religion 2"
            case .CAFS:
                return "CAFS"
            case .physics:
                return "Physics"
            case .societyAndCulture:
                return "Society and Culture"
            case .businessStudies:
                return "Business Studies"
            case .PDHPE:
                return "PDHPE"
            case .foodTechnology:
                return "Food Tech"
            case .biology:
                return "Biology"
            case .englishExtension1:
                return "English Extension 1"
            case .IPT:
                return "IPT"
            case .geography:
                return "Geography"
            case .VETConstruction:
                return "Construction"
            case .mathematicsExtension1:
                return "Maths Extension 1"
            case .drama:
                return "Drama"
            case .VETBusinessServices:
                return "Business Services"
            case .historyExtension:
                return "History Extension"
            case .textilesAndDesign:
                return "Textiles And Design"
            }
            
        }
    }
    
    static func alphabeticallySorted() -> [Subject] {
        
        return self.asArray.sorted(by: {$0.subjectName.lowercased() < $1.subjectName.lowercased()})
        
    }
    
}
