//
//  RiskAssessmentEngine.swift
//  LenderCheck
//

import Foundation

public protocol RiskAssessmentEngineProtocol {
    func getDiagnosticQuestions() -> [RiskQuestion]
    func calculateRisk(selectedOptionIds: [String]) -> RiskAssessmentResult
    func analyzeTextOrSMS(content: String) -> TextScanResult
}

public class RiskAssessmentEngine: RiskAssessmentEngineProtocol {
    public static let shared = RiskAssessmentEngine()

    public init() {}

    public func getDiagnosticQuestions() -> [RiskQuestion] {
        return [
            RiskQuestion(
                id: 1,
                title: "Upfront Fee or Advance Security Deposit",
                subtitle: "Did the lender ask you to transfer any money (processing fee, GST, file charge, insurance) before disbursing the loan?",
                icon: "banknote.fill",
                options: [
                    RiskOption(
                        id: "q1_opt1",
                        text: "No upfront payment requested (Deducted from disbursed loan directly)",
                        riskPenalty: 0
                    ),
                    RiskOption(
                        id: "q1_opt2",
                        text: "Yes, they asked for ₹500 - ₹5,000 upfront via UPI / Bank transfer before loan release",
                        riskPenalty: 40,
                        redFlagDescription: "CRITICAL RED FLAG: Legitimate lenders NEVER ask for advance fees or security deposits prior to loan disbursal."
                    ),
                    RiskOption(
                        id: "q1_opt3",
                        text: "They claim it's a refundable GST verification fee",
                        riskPenalty: 40,
                        redFlagDescription: "SCAM ALERT: Scammers frequently use 'Refundable GST' or 'Loan Card' fees to steal money."
                    )
                ]
            ),
            RiskQuestion(
                id: 2,
                title: "App Permissions Requested",
                subtitle: "What mobile permissions did their mobile app or link demand?",
                icon: "lock.shield.fill",
                options: [
                    RiskOption(
                        id: "q2_opt1",
                        text: "Standard permissions (SMS for OTP, Camera for KYC, Location for compliance)",
                        riskPenalty: 0
                    ),
                    RiskOption(
                        id: "q2_opt2",
                        text: "Demands full access to Phone Contacts, Photo Gallery & Files",
                        riskPenalty: 35,
                        redFlagDescription: "EXTORTION THREAT: RBI strictly prohibits lending apps from accessing mobile contacts and photo galleries. This data is weaponized for blackmail."
                    ),
                    RiskOption(
                        id: "q2_opt3",
                        text: "Not sure / I downloaded a direct APK outside the official App Store / Play Store",
                        riskPenalty: 30,
                        redFlagDescription: "HIGH RISK: Sideloaded APK files bypass security vetting and often contain spyware."
                    )
                ]
            ),
            RiskQuestion(
                id: 3,
                title: "Repayment Period & Tenure",
                subtitle: "What is the loan repayment timeframe offered?",
                icon: "calendar.badge.clock",
                options: [
                    RiskOption(
                        id: "q3_opt1",
                        text: "Standard 3 months, 6 months, 12+ months with clear EMI schedule",
                        riskPenalty: 0
                    ),
                    RiskOption(
                        id: "q3_opt2",
                        text: "Extremely short: 7 days or 15 days only",
                        riskPenalty: 35,
                        redFlagDescription: "7-DAY TRAP: Predatory loan apps deliberately trap borrowers in impossible 7-day cycles with 300%+ APR."
                    ),
                    RiskOption(
                        id: "q3_opt3",
                        text: "No clear tenure mentioned, only 'Instant Cash now'",
                        riskPenalty: 25,
                        redFlagDescription: "LACK OF TRANSPARENCY: Regulated lenders are legally mandated to disclose the Key Fact Statement (KFS) upfront."
                    )
                ]
            ),
            RiskQuestion(
                id: 4,
                title: "Communication Channel & Sanction Letter",
                subtitle: "How did they contact you and send the approval letter?",
                icon: "envelope.badge.fill",
                options: [
                    RiskOption(
                        id: "q4_opt1",
                        text: "Official corporate email domain (e.g., @hdfcbank.com, @kreditbee.in) & registered app notification",
                        riskPenalty: 0
                    ),
                    RiskOption(
                        id: "q4_opt2",
                        text: "Random WhatsApp number, Telegram group, or free @gmail.com / @yahoo.com address",
                        riskPenalty: 30,
                        redFlagDescription: "IMPERSONATION RISK: Regulated lenders never issue sanction letters from personal WhatsApp or free Gmail accounts."
                    ),
                    RiskOption(
                        id: "q4_opt3",
                        text: "Unsolicited SMS with shortlink claiming pre-approval without credit check",
                        riskPenalty: 25,
                        redFlagDescription: "PHISHING SMISHING: Mass SMS with pre-approval guarantees are common phishing hooks."
                    )
                ]
            ),
            RiskQuestion(
                id: 5,
                title: "Regulatory & NBFC Transparency",
                subtitle: "Did they explicitly state which RBI-registered NBFC or Bank is issuing the funds?",
                icon: "building.columns.fill",
                options: [
                    RiskOption(
                        id: "q5_opt1",
                        text: "Yes, explicit NBFC name and RBI Registration Number provided and verifiable",
                        riskPenalty: 0
                    ),
                    RiskOption(
                        id: "q5_opt2",
                        text: "No NBFC mentioned, or vague claims like 'Approved by all Banks'",
                        riskPenalty: 30,
                        redFlagDescription: "REGULATORY EVASION: RBI Digital Lending Guidelines require all loan apps to disclose their registered lending partner on their homepage."
                    ),
                    RiskOption(
                        id: "q5_opt3",
                        text: "They sent a certificate with the RBI logo (RBI does NOT issue individual loan approvals)",
                        riskPenalty: 40,
                        redFlagDescription: "FORGED RBI CERTIFICATE: RBI has repeatedly warned that it NEVER issues loan approval certificates to individuals."
                    )
                ]
            )
        ]
    }

    public func calculateRisk(selectedOptionIds: [String]) -> RiskAssessmentResult {
        var penalty = 0
        var detectedFlags: [String] = []
        let allQuestions = getDiagnosticQuestions()

        for question in allQuestions {
            for option in question.options {
                if selectedOptionIds.contains(option.id) {
                    penalty += option.riskPenalty
                    if let flag = option.redFlagDescription {
                        detectedFlags.append(flag)
                    }
                }
            }
        }

        let safetyScore = max(0, 100 - penalty)
        let riskLevel: RiskLevel

        if safetyScore >= 80 {
            riskLevel = .safe
        } else if safetyScore >= 55 {
            riskLevel = .moderate
        } else if safetyScore >= 30 {
            riskLevel = .highRisk
        } else {
            riskLevel = .criticalScam
        }

        var recommendations: [String] = []

        if safetyScore < 55 {
            recommendations.append("DO NOT transfer any advance processing fee or GST.")
            recommendations.append("DO NOT grant contacts or gallery permissions to this app.")
            recommendations.append("Verify the lending partner on the official RBI NBFC registry.")
            recommendations.append("If harassed, report immediately to Cybercrime Helpline 1930.")
        } else if safetyScore < 80 {
            recommendations.append("Request a formal Key Fact Statement (KFS) including Annual Percentage Rate (APR).")
            recommendations.append("Ensure the app is downloaded strictly from official Google Play / Apple App Store.")
            recommendations.append("Cross-check the NBFC name listed in the app terms.")
        } else {
            recommendations.append("Lender exhibits standard legitimate operating practices.")
            recommendations.append("Always verify the official domain before entering banking credentials.")
        }

        return RiskAssessmentResult(
            safetyScore: safetyScore,
            riskLevel: riskLevel,
            detectedRedFlags: detectedFlags,
            recommendations: recommendations,
            timestamp: Date()
        )
    }

    public func analyzeTextOrSMS(content: String) -> TextScanResult {
        let text = content.lowercased()
        var detected: [String] = []
        var scorePenalty = 0

        // Scam signal rules
        let rules: [(pattern: String, label: String, penalty: Int)] = [
            ("pay.*fee|processing fee|file charge|security deposit|refundable gst", "Demands Upfront Payment / Fee", 35),
            ("@gmail\\.com|@yahoo\\.com|@hotmail\\.com|@outlook\\.com", "Uses Free Email Provider (Not Corporate Domain)", 25),
            ("without cibil|no cibil required|guaranteed approval|100% approved", "Unrealistic 'No CIBIL' Guarantee", 20),
            ("7 day|7-day|7days|repay in 7 days|repay in 6 days", "Predatory 7-Day Repayment Cycle", 35),
            ("wa\\.me|t\\.me|telegram|whatsapp to claim", "Directs to WhatsApp / Telegram Messenger", 25),
            ("rbi approved certificate|rbi approval letter|rbi seal", "Claims Direct RBI Approval Certificate (Known Forgery)", 30),
            ("\\.apk|download apk|install apk", "Direct APK Sideloading Link", 30),
            ("urgent.*minutes|within 5 min|within 10 min", "High-Pressure Urgency Tactics", 15),
            ("contact list|gallery permission", "Contact Scraping Threat", 30)
        ]

        for rule in rules {
            if let regex = try? NSRegularExpression(pattern: rule.pattern, options: .caseInsensitive) {
                let range = NSRange(text.startIndex..., in: text)
                if regex.firstMatch(in: text, options: [], range: range) != nil {
                    detected.append(rule.label)
                    scorePenalty += rule.penalty
                }
            }
        }

        let scamProb = min(100, max(0, scorePenalty == 0 ? (text.isEmpty ? 0 : 5) : scorePenalty))
        let isHighRisk = scamProb >= 50

        let summary: String
        var advice: [String] = []

        if detected.isEmpty {
            summary = "No obvious predatory scam patterns detected in this message. However, always verify the sender's official credentials before taking action."
            advice = [
                "Verify the sender's official website.",
                "Ensure repayment terms are greater than 90 days."
            ]
        } else if isHighRisk {
            summary = "DANGER: High probability of a predatory or fraudulent loan offer. Multiple critical red flags were detected."
            advice = [
                "NEVER send money or advance fees.",
                "Do NOT click unverified shortlinks or download unknown APKs.",
                "Block and report the sender number."
            ]
        } else {
            summary = "SUSPICIOUS: Moderate caution flags detected. Review the lender's regulatory credentials carefully."
            advice = [
                "Cross-check if the sender uses an official corporate domain.",
                "Verify their registered NBFC partner on RBI's website."
            ]
        }

        return TextScanResult(
            scamProbabilityScore: scamProb,
            isHighRisk: isHighRisk,
            detectedKeywords: detected,
            summary: summary,
            advice: advice
        )
    }
}
