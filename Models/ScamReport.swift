//
//  ScamReport.swift
//  LenderCheck
//

import Foundation

public struct ScamReport: Identifiable, Codable {
    public let id: UUID
    public let appName: String
    public let lenderOrCompanyClaimed: String
    public let scamCategory: String // "Extortion / Harassment", "Upfront Processing Fee Fraud", "7-Day Fake Loan", "Identity Theft", "Fake Approval SMS"
    public let description: String
    public let dateReported: Date
    public let reportCount: Int
    public let status: String // "Verified Illegal", "Under Investigation", "Confirmed Phishing"
    public let contactChannelsUsed: [String] // "WhatsApp", "Telegram", "SMS", "Direct APK"

    public init(
        id: UUID = UUID(),
        appName: String,
        lenderOrCompanyClaimed: String,
        scamCategory: String,
        description: String,
        dateReported: Date = Date(),
        reportCount: Int = 1,
        status: String = "Verified Illegal",
        contactChannelsUsed: [String] = ["WhatsApp", "Direct APK"]
    ) {
        self.id = id
        self.appName = appName
        self.lenderOrCompanyClaimed = lenderOrCompanyClaimed
        self.scamCategory = scamCategory
        self.description = description
        self.dateReported = dateReported
        self.reportCount = reportCount
        self.status = status
        self.contactChannelsUsed = contactChannelsUsed
    }
}

public struct ScamModusOperandi: Identifiable {
    public let id = UUID()
    public let title: String
    public let icon: String
    public let summary: String
    public let howItWorks: String
    public let howToSpot: [String]
    public let actionIfTrapped: String
}
