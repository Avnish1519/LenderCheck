//
//  LenderRegistryService.swift
//  LenderCheck
//

import Foundation

public protocol LenderRegistryServiceProtocol {
    func searchLenders(query: String, category: LenderCategory) -> [Lender]
    func getAllLenders() -> [Lender]
    func getLender(by id: UUID) -> Lender?
    func getLendersByCategory(_ category: LenderCategory) -> [Lender]
}

public class LenderRegistryService: LenderRegistryServiceProtocol {
    public static let shared = LenderRegistryService()

    private let lenders: [Lender] = [
        // MARK: - Commercial Banks
        Lender(
            name: "HDFC Bank",
            legalEntityName: "HDFC Bank Limited",
            type: "Scheduled Commercial Bank",
            category: .banks,
            regNumber: "RBI/BANK/1994/01",
            regulatoryBody: "Reserve Bank of India (RBI)",
            verificationStatus: .verifiedOfficial,
            officialWebsite: "https://www.hdfcbank.com",
            customerCarePhone: "1800 202 6161",
            officialGrievanceEmail: "grievance.redressal@hdfcbank.com",
            authorizedAppNames: ["HDFC Bank MobileBanking", "PayZapp", "SmartBuy"],
            redFlags: [],
            description: "Leading private sector bank licensed directly under the Banking Regulation Act, 1949.",
            headquarters: "Mumbai, Maharashtra"
        ),
        Lender(
            name: "State Bank of India (SBI)",
            legalEntityName: "State Bank of India",
            type: "Public Sector Commercial Bank",
            category: .banks,
            regNumber: "RBI/PSU/1955/01",
            regulatoryBody: "Reserve Bank of India (RBI)",
            verificationStatus: .verifiedOfficial,
            officialWebsite: "https://www.sbi.co.in",
            customerCarePhone: "1800 1234",
            officialGrievanceEmail: "customercare@sbi.co.in",
            authorizedAppNames: ["YONO SBI", "SBI Quick", "YONO Lite"],
            redFlags: [],
            description: "India's largest public sector bank governed by State Bank of India Act, 1955.",
            headquarters: "Mumbai, Maharashtra"
        ),
        Lender(
            name: "ICICI Bank",
            legalEntityName: "ICICI Bank Limited",
            type: "Scheduled Commercial Bank",
            category: .banks,
            regNumber: "RBI/BANK/1994/02",
            regulatoryBody: "Reserve Bank of India (RBI)",
            verificationStatus: .verifiedOfficial,
            officialWebsite: "https://www.icicibank.com",
            customerCarePhone: "1800 1080",
            officialGrievanceEmail: "headservicequality@icicibank.com",
            authorizedAppNames: ["iMobile Pay", "InstaBIZ", "Pockets"],
            redFlags: [],
            description: "Major scheduled private sector bank operating under RBI regulatory oversight.",
            headquarters: "Mumbai, Maharashtra"
        ),
        Lender(
            name: "Axis Bank",
            legalEntityName: "Axis Bank Limited",
            type: "Scheduled Commercial Bank",
            category: .banks,
            regNumber: "RBI/BANK/1993/03",
            regulatoryBody: "Reserve Bank of India (RBI)",
            verificationStatus: .verifiedOfficial,
            officialWebsite: "https://www.axisbank.com",
            customerCarePhone: "1860 419 5555",
            officialGrievanceEmail: "nodalofficer@axisbank.com",
            authorizedAppNames: ["Axis Mobile", "Freecharge"],
            redFlags: [],
            description: "Licensed scheduled commercial bank under RBI supervision.",
            headquarters: "Mumbai, Maharashtra"
        ),

        // MARK: - Regulated NBFCs
        Lender(
            name: "Bajaj Finserv (Bajaj Finance)",
            legalEntityName: "Bajaj Finance Limited",
            type: "RBI Registered NBFC-ND-SI",
            category: .nbfcs,
            regNumber: "NBFC/RBI/B.13.00442",
            regulatoryBody: "Reserve Bank of India (RBI)",
            verificationStatus: .regulatedNBFC,
            officialWebsite: "https://www.bajajfinserv.in",
            customerCarePhone: "086980 10101",
            officialGrievanceEmail: "grievanceredressalteam@bajajfinserv.in",
            authorizedAppNames: ["Bajaj Finserv App", "Bajaj Pay"],
            redFlags: [],
            description: "Large Systemically Important Non-Banking Financial Company (NBFC-ND-SI) regulated by RBI.",
            headquarters: "Pune, Maharashtra"
        ),
        Lender(
            name: "Tata Capital",
            legalEntityName: "Tata Capital Financial Services Limited",
            type: "RBI Registered NBFC",
            category: .nbfcs,
            regNumber: "NBFC/RBI/N.13.01823",
            regulatoryBody: "Reserve Bank of India (RBI)",
            verificationStatus: .regulatedNBFC,
            officialWebsite: "https://www.tatacapital.com",
            customerCarePhone: "1860 267 6060",
            officialGrievanceEmail: "customercare@tatacapital.com",
            authorizedAppNames: ["Tata Capital Mobile App"],
            redFlags: [],
            description: "Subsidiary of Tata Sons, holding a registered Certificate of Registration from RBI.",
            headquarters: "Mumbai, Maharashtra"
        ),
        Lender(
            name: "Aditya Birla Finance",
            legalEntityName: "Aditya Birla Finance Limited",
            type: "RBI Registered NBFC",
            category: .nbfcs,
            regNumber: "NBFC/RBI/N.13.01180",
            regulatoryBody: "Reserve Bank of India (RBI)",
            verificationStatus: .regulatedNBFC,
            officialWebsite: "https://finance.adityabirlacapital.com",
            customerCarePhone: "1800 270 7000",
            officialGrievanceEmail: "abfl.grievance@adityabirlacapital.com",
            authorizedAppNames: ["Aditya Birla Capital App"],
            redFlags: [],
            description: "Registered NBFC with RBI providing retail, personal, and corporate loans.",
            headquarters: "Mumbai, Maharashtra"
        ),

        // MARK: - Authorized Digital Lending Apps (DLAs)
        Lender(
            name: "MoneyView",
            legalEntityName: "Whizdm Innovations Pvt. Ltd. (Lending Partner: Whizdm Finance NBFC)",
            type: "Authorized Digital Lending Partner",
            category: .digitalApps,
            regNumber: "NBFC/RBI/N-02.00244 (Whizdm Finance)",
            regulatoryBody: "Reserve Bank of India (RBI)",
            verificationStatus: .authorizedPartner,
            officialWebsite: "https://moneyview.in",
            customerCarePhone: "080 6939 0476",
            officialGrievanceEmail: "grievance@moneyview.in",
            authorizedAppNames: ["Moneyview: Personal Loan App"],
            redFlags: [],
            description: "Authorized digital lending platform operating via RBI-licensed NBFC partners (Whizdm Finance, DMI Finance, Clix Capital).",
            headquarters: "Bengaluru, Karnataka"
        ),
        Lender(
            name: "KreditBee",
            legalEntityName: "Finnov Private Limited (Lending Partner: Krazybee Services NBFC)",
            type: "Authorized Digital Lending Partner",
            category: .digitalApps,
            regNumber: "NBFC/RBI/N-02.00305 (Krazybee Services)",
            regulatoryBody: "Reserve Bank of India (RBI)",
            verificationStatus: .authorizedPartner,
            officialWebsite: "https://www.kreditbee.in",
            customerCarePhone: "080 4429 2200",
            officialGrievanceEmail: "grievance@kreditbee.in",
            authorizedAppNames: ["KreditBee: Quick Personal Loan"],
            redFlags: [],
            description: "Digital lending application backed by RBI registered NBFC Krazybee Services Pvt. Ltd.",
            headquarters: "Bengaluru, Karnataka"
        ),
        Lender(
            name: "Navi",
            legalEntityName: "Navi Finserv Limited",
            type: "RBI Registered NBFC-ND",
            category: .digitalApps,
            regNumber: "NBFC/RBI/N.09.00445",
            regulatoryBody: "Reserve Bank of India (RBI)",
            verificationStatus: .authorizedPartner,
            officialWebsite: "https://navi.com",
            customerCarePhone: "080 6906 4200",
            officialGrievanceEmail: "grievance@navi.com",
            authorizedAppNames: ["Navi: UPI, Loans, MF"],
            redFlags: [],
            description: "Direct NBFC-owned digital lending app offering personal and home loans under RBI compliance.",
            headquarters: "Bengaluru, Karnataka"
        ),
        Lender(
            name: "CASHe",
            legalEntityName: "Aeries Financial Technologies (Partner: Bhanix Finance and Investment Ltd)",
            type: "Authorized Digital Lending Partner",
            category: .digitalApps,
            regNumber: "NBFC/RBI/N-13.01887 (Bhanix Finance)",
            regulatoryBody: "Reserve Bank of India (RBI)",
            verificationStatus: .authorizedPartner,
            officialWebsite: "https://www.cashe.co.in",
            customerCarePhone: "022 4607 9900",
            officialGrievanceEmail: "grievance@cashe.co.in",
            authorizedAppNames: ["CASHe: Personal Loan App"],
            redFlags: [],
            description: "Digital lending app operating under Bhanix Finance, a regulated NBFC in India.",
            headquarters: "Mumbai, Maharashtra"
        ),

        // MARK: - Blacklisted / Flagged Predatory Scam Apps
        Lender(
            name: "QuickCash Pro",
            legalEntityName: "Fake Unregistered Shell (Purported QuickPay Media)",
            type: "Illegal Predatory Loan APK",
            category: .flagged,
            regNumber: nil,
            regulatoryBody: "Unregistered / Illegal Operation",
            verificationStatus: .blacklistedScam,
            officialWebsite: nil,
            customerCarePhone: nil,
            officialGrievanceEmail: "quickcashhelp2024@gmail.com",
            authorizedAppNames: ["QuickCash Pro APK", "Quick Loan 7 Days"],
            redFlags: [
                "Demands full gallery & contacts access before showing terms",
                "Offers only 7-day loan tenure with 45% upfront deductions",
                "Operates via random WhatsApp numbers with abusive recovery agents",
                "Not listed on RBI Whitelist or official Play Store"
            ],
            description: "CRITICAL DANGER: Known extortion racket disguised as an instant loan app. Blacklisted by cybercrime monitoring cells for harassing users' contacts.",
            headquarters: "Unknown / Foreign Hosted"
        ),
        Lender(
            name: "InstaLoan24",
            legalEntityName: "Unregistered Entity",
            type: "Phishing / Upfront Fee Scam",
            category: .flagged,
            regNumber: nil,
            regulatoryBody: "Unregistered / Illegal Operation",
            verificationStatus: .blacklistedScam,
            officialWebsite: nil,
            customerCarePhone: nil,
            officialGrievanceEmail: "loanapproval.instant@gmail.com",
            authorizedAppNames: ["InstaLoan 24x7 App"],
            redFlags: [
                "Demands upfront 'Security Deposit' or 'File Charge' of ₹1,500 to release loan",
                "Sends forged sanction letters with fake RBI / government emblems",
                "Uses free Gmail/Yahoo email addresses for communication",
                "Disappears after receiving the advance payment without disbursing loan"
            ],
            description: "ADVANCE FEE FRAUD: Solicits upfront payments under the pretext of GST/file charges. Legitimate lenders never demand advance fees from borrowers.",
            headquarters: "Fake Delhi Address"
        ),
        Lender(
            name: "RupeeGo Rush",
            legalEntityName: "Unverified Shadow APK",
            type: "Extortion / Contact Scraping App",
            category: .flagged,
            regNumber: nil,
            regulatoryBody: "Unregistered / Illegal Operation",
            verificationStatus: .blacklistedScam,
            officialWebsite: nil,
            customerCarePhone: nil,
            officialGrievanceEmail: nil,
            authorizedAppNames: ["RupeeGo Rush APK"],
            redFlags: [
                "Transfers small amount without explicit user consent, then demands 3x within 6 days",
                "Threatens to circulate morphed photographs to phone contacts",
                "No legitimate RBI registration or physical registered office"
            ],
            description: "HARASSMENT APP: Illegally scrapes contact books and photo libraries to blackmail borrowers for exorbitant interest.",
            headquarters: "Unverified"
        ),
        Lender(
            name: "PocketSalary Flash",
            legalEntityName: "Unknown Entity",
            type: "Fake Loan APK",
            category: .flagged,
            regNumber: nil,
            regulatoryBody: "Unregistered / Illegal Operation",
            verificationStatus: .blacklistedScam,
            officialWebsite: nil,
            customerCarePhone: nil,
            officialGrievanceEmail: nil,
            authorizedAppNames: ["Pocket Salary Flash"],
            redFlags: [
                "Distributed solely via Telegram and WhatsApp APK download links",
                "Contains spyware targeting mobile financial SMS and contacts",
                "Fake RBI NOC certificates attached in WhatsApp messages"
            ],
            description: "MALICIOUS APK: Unofficial Android application file designed to infect devices and siphon sensitive contacts.",
            headquarters: "Unknown"
        )
    ]

    public init() {}

    public func getAllLenders() -> [Lender] {
        return lenders
    }

    public func getLender(by id: UUID) -> Lender? {
        return lenders.first { $0.id == id }
    }

    public func getLendersByCategory(_ category: LenderCategory) -> [Lender] {
        if category == .all {
            return lenders
        }
        return lenders.filter { $0.category == category }
    }

    public func searchLenders(query: String, category: LenderCategory = .all) -> [Lender] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let pool = category == .all ? lenders : lenders.filter { $0.category == category }

        if trimmed.isEmpty {
            return pool
        }

        return pool.filter { lender in
            lender.name.lowercased().contains(trimmed) ||
            lender.legalEntityName.lowercased().contains(trimmed) ||
            (lender.regNumber?.lowercased().contains(trimmed) ?? false) ||
            lender.authorizedAppNames.contains { $0.lowercased().contains(trimmed) }
        }
    }
}
