//
//  Lender.swift
//  LenderCheck
//

import Foundation

public enum VerificationStatus: String, Codable, CaseIterable {
    case verifiedOfficial = "Verified Official"
    case regulatedNBFC = "Regulated NBFC"
    case authorizedPartner = "Authorized Digital Partner"
    case cautionUnverified = "Unverified / Unknown"
    case blacklistedScam = "Blacklisted Scam App"

    public var badgeColorName: String {
        switch self {
        case .verifiedOfficial, .regulatedNBFC, .authorizedPartner:
            return "green"
        case .cautionUnverified:
            return "orange"
        case .blacklistedScam:
            return "red"
        }
    }

    public var systemIcon: String {
        switch self {
        case .verifiedOfficial, .regulatedNBFC:
            return "checkmark.seal.fill"
        case .authorizedPartner:
            return "shield.lefthalf.filled.badge.checkmark"
        case .cautionUnverified:
            return "exclamationmark.triangle.fill"
        case .blacklistedScam:
            return "xmark.octagon.fill"
        }
    }
}

public enum LenderCategory: String, Codable, CaseIterable, Identifiable {
    case all = "All"
    case banks = "Banks"
    case nbfcs = "NBFCs"
    case digitalApps = "Digital Lending Apps"
    case flagged = "Flagged Scams"

    public var id: String { rawValue }
}

public struct Lender: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let legalEntityName: String
    public let type: String // "Scheduled Commercial Bank", "RBI Registered NBFC", "Digital Lending Partner", "Illegal APK / Scam"
    public let category: LenderCategory
    public let regNumber: String?
    public let regulatoryBody: String // "Reserve Bank of India (RBI)", "Unregistered / Unknown"
    public let verificationStatus: VerificationStatus
    public let officialWebsite: String?
    public let customerCarePhone: String?
    public let officialGrievanceEmail: String?
    public let authorizedAppNames: [String]
    public let redFlags: [String]
    public let description: String
    public let headquarters: String?

    public init(
        id: UUID = UUID(),
        name: String,
        legalEntityName: String,
        type: String,
        category: LenderCategory,
        regNumber: String?,
        regulatoryBody: String = "Reserve Bank of India (RBI)",
        verificationStatus: VerificationStatus,
        officialWebsite: String? = nil,
        customerCarePhone: String? = nil,
        officialGrievanceEmail: String? = nil,
        authorizedAppNames: [String] = [],
        redFlags: [String] = [],
        description: String,
        headquarters: String? = nil
    ) {
        self.id = id
        self.name = name
        self.legalEntityName = legalEntityName
        self.type = type
        self.category = category
        self.regNumber = regNumber
        self.regulatoryBody = regulatoryBody
        self.verificationStatus = verificationStatus
        self.officialWebsite = officialWebsite
        self.customerCarePhone = customerCarePhone
        self.officialGrievanceEmail = officialGrievanceEmail
        self.authorizedAppNames = authorizedAppNames
        self.redFlags = redFlags
        self.description = description
        self.headquarters = headquarters
    }

    public var isVerified: Bool {
        return verificationStatus == .verifiedOfficial || verificationStatus == .regulatedNBFC || verificationStatus == .authorizedPartner
    }
}
