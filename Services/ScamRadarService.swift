//
//  ScamRadarService.swift
//  LenderCheck
//

import Foundation

public protocol ScamRadarServiceProtocol {
    func getLiveScamReports() -> [ScamReport]
    func getModusOperandiList() -> [ScamModusOperandi]
    func submitReport(appName: String, companyClaimed: String, category: String, description: String, channels: [String]) -> ScamReport
}

public class ScamRadarService: ScamRadarServiceProtocol {
    public static let shared = ScamRadarService()

    private var reports: [ScamReport] = [
        ScamReport(
            appName: "FastRupee Cash VIP",
            lenderOrCompanyClaimed: "Purported 'FastRupee Finance Ltd'",
            scamCategory: "Extortion / Harassment",
            description: "App demanded contacts access upon launch. Loan of ₹3,000 disbursed, but within 6 days abusive agents started calling parents and employer demanding ₹8,500.",
            dateReported: Date().addingTimeInterval(-3600 * 4),
            reportCount: 142,
            status: "Verified Illegal",
            contactChannelsUsed: ["Direct APK", "WhatsApp"]
        ),
        ScamReport(
            appName: "BharatCredit 24",
            lenderOrCompanyClaimed: "Impersonating SBI Digital",
            scamCategory: "Upfront Processing Fee Fraud",
            description: "Sent forged loan sanction letter with RBI seal via WhatsApp. Demanded ₹2,400 as 'GST Clearance Fee'. Disappeared immediately upon receiving payment.",
            dateReported: Date().addingTimeInterval(-3600 * 18),
            reportCount: 89,
            status: "Confirmed Phishing",
            contactChannelsUsed: ["WhatsApp", "SMS"]
        ),
        ScamReport(
            appName: "QuickLoan Spark",
            lenderOrCompanyClaimed: "Unregistered Shell",
            scamCategory: "7-Day Fake Loan",
            description: "Offers instant loan without KYC, charges 40% upfront deduction. On Day 6, threatens to send morphed photos to WhatsApp contact groups.",
            dateReported: Date().addingTimeInterval(-3600 * 36),
            reportCount: 215,
            status: "Verified Illegal",
            contactChannelsUsed: ["Direct APK", "Telegram"]
        ),
        ScamReport(
            appName: "InstantPocket 50K",
            lenderOrCompanyClaimed: "Unknown Group",
            scamCategory: "Identity Theft",
            description: "Collected Aadhaar & PAN photos without OTP verification, followed by phishing links to extract net banking credentials.",
            dateReported: Date().addingTimeInterval(-3600 * 72),
            reportCount: 54,
            status: "Under Investigation",
            contactChannelsUsed: ["SMS", "Web Link"]
        )
    ]

    private let modusOperandiList: [ScamModusOperandi] = [
        ScamModusOperandi(
            title: "The 7-Day Extortion Trap",
            icon: "exclamationmark.bubble.fill",
            summary: "Predatory apps lure victims with instant approvals, disburse partial amounts, and harass family/contacts on Day 6.",
            howItWorks: "The app requires full contact list permissions during install. You ask for ₹5,000, they deposit ₹3,000 (calling ₹2,000 a fee) and demand ₹7,000 within 6–7 days. If delayed, recovery agents call your phone contacts with defamatory messages.",
            howToSpot: [
                "Tenure is less than 30 days (RBI mandates minimum tenure).",
                "App requires contacts, camera, or photo gallery permissions.",
                "Not available on official Apple App Store or Google Play Store."
            ],
            actionIfTrapped: "1. Do NOT pay repeated extortion amounts. 2. Inform your contacts that your device was compromised. 3. Call 1930 and file a complaint at cybercrime.gov.in."
        ),
        ScamModusOperandi(
            title: "Upfront Fee & Fake RBI Sanction Letters",
            icon: "doc.text.badge.plus",
            summary: "Scammers send official-looking loan approval letters with forged RBI emblems and demand advance 'processing' or 'insurance' fees.",
            howItWorks: "Victim receives an SMS or WhatsApp claiming a ₹5,00,000 pre-approved loan at 2% interest. A PDF with government logos is shared. The scammer asks for ₹2,500 'File Opening Charge' or 'GST', promising disbursement once paid. They block you immediately after transfer.",
            howToSpot: [
                "Legitimate banks deduct processing fees from the loan amount itself.",
                "RBI never issues individual loan sanction letters or approvals.",
                "Sender uses @gmail.com or personal WhatsApp numbers."
            ],
            actionIfTrapped: "Never transfer advance fees. If already transferred, report the transaction UTR number to your bank immediately to freeze the recipient account."
        ),
        ScamModusOperandi(
            title: "Shadow APKs & Malicious Clones",
            icon: "arrow.down.doc.fill",
            summary: "Fake apps that clone the branding of reputable lenders (like Bajaj, Tata Capital, or KreditBee) distributed via SMS links.",
            howItWorks: "Fraudsters send SMS links containing APK downloads mimicking trusted brands. Once installed, malware reads OTPs, contact books, and messages, silently stealing funds.",
            howToSpot: [
                "Sent via SMS with shortlinks (bit.ly, tinyurl, or suspicious .apk links).",
                "App icon or name has minor misspellings (e.g. 'BajajFinsrv' or 'KreditBe').",
                "Developer name is an unverified individual instead of corporate entity."
            ],
            actionIfTrapped: "Immediately uninstall the app, revoke device administrator permissions, change bank passwords from another device, and format your phone."
        )
    ]

    public init() {}

    public func getLiveScamReports() -> [ScamReport] {
        return reports
    }

    public func getModusOperandiList() -> [ScamModusOperandi] {
        return modusOperandiList
    }

    public func submitReport(
        appName: String,
        companyClaimed: String,
        category: String,
        description: String,
        channels: [String]
    ) -> ScamReport {
        let newReport = ScamReport(
            appName: appName,
            lenderOrCompanyClaimed: companyClaimed,
            scamCategory: category,
            description: description,
            dateReported: Date(),
            reportCount: 1,
            status: "Community Flagged",
            contactChannelsUsed: channels.isEmpty ? ["Direct APK"] : channels
        )
        reports.insert(newReport, at: 0)
        return newReport
    }
}
