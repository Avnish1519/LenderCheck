//
//  RiskAssessment.swift
//  LenderCheck
//

import Foundation

public enum RiskLevel: String, Codable {
    case safe = "Low Risk / Safe"
    case moderate = "Moderate Caution Needed"
    case highRisk = "High Risk / Probable Scam"
    case criticalScam = "CRITICAL / CONFIRMED SCAM PATTERN"

    public var colorName: String {
        switch self {
        case .safe: return "green"
        case .moderate: return "orange"
        case .highRisk: return "red"
        case .criticalScam: return "purple"
        }
    }

    public var iconName: String {
        switch self {
        case .safe: return "shield.checkmark.fill"
        case .moderate: return "exclamationmark.triangle.fill"
        case .highRisk: return "xmark.shield.fill"
        case .criticalScam: return "flame.fill"
        }
    }
}

public struct RiskOption: Identifiable, Hashable {
    public let id: String
    public let text: String
    public let riskPenalty: Int // 0 to 40 points penalty
    public let redFlagDescription: String?

    public init(id: String, text: String, riskPenalty: Int, redFlagDescription: String? = nil) {
        self.id = id
        self.text = text
        self.riskPenalty = riskPenalty
        self.redFlagDescription = redFlagDescription
    }
}

public struct RiskQuestion: Identifiable {
    public let id: Int
    public let title: String
    public let subtitle: String
    public let icon: String
    public let options: [RiskOption]
}

public struct RiskAssessmentResult {
    public let safetyScore: Int // 0 to 100
    public let riskLevel: RiskLevel
    public let detectedRedFlags: [String]
    public let recommendations: [String]
    public let timestamp: Date
}

public struct TextScanResult: Identifiable {
    public let id = UUID()
    public let scamProbabilityScore: Int // 0 to 100
    public let isHighRisk: Bool
    public let detectedKeywords: [String]
    public let summary: String
    public let advice: [String]
}
