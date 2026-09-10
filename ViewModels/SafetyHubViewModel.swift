//
//  SafetyHubViewModel.swift
//  LenderCheck
//

import Foundation
import Combine

public class SafetyHubViewModel: ObservableObject {
    @Published public var checklistItems: [SafetyChecklistItem] = [
        SafetyChecklistItem(
            id: "chk_1",
            title: "Check RBI / NBFC Registration Number",
            detail: "Ensure the lender's registration number is listed on the official RBI NBFC whitelist.",
            isMandatory: true,
            isChecked: false,
            icon: "checkmark.seal.fill"
        ),
        SafetyChecklistItem(
            id: "chk_2",
            title: "Zero Upfront Fees Paid",
            detail: "Confirm you have NOT transferred any advance processing, insurance, or GST fees.",
            isMandatory: true,
            isChecked: false,
            icon: "banknote.fill"
        ),
        SafetyChecklistItem(
            id: "chk_3",
            title: "App Downloaded Strictly from App Store",
            detail: "Never install sideloaded APKs or web profile installers sent via WhatsApp / Telegram.",
            isMandatory: true,
            isChecked: false,
            icon: "app.badge.checkmark"
        ),
        SafetyChecklistItem(
            id: "chk_4",
            title: "Review App Permissions Requested",
            detail: "The app must NOT request access to contacts, photos, or device media storage.",
            isMandatory: true,
            isChecked: false,
            icon: "hand.raised.fill"
        ),
        SafetyChecklistItem(
            id: "chk_5",
            title: "Received Key Fact Statement (KFS)",
            detail: "The lender provided transparent APR, total repayment amount, and grievance officer details.",
            isMandatory: true,
            isChecked: false,
            icon: "doc.text.fill"
        )
    ]

    public func toggleChecklist(id: String) {
        if let index = checklistItems.firstIndex(where: { $0.id == id }) {
            checklistItems[index].isChecked.toggle()
        }
    }

    public var completedCount: Int {
        checklistItems.filter { $0.isChecked }.count
    }

    public var totalCount: Int {
        checklistItems.count
    }

    public var progressPercentage: Double {
        guard totalCount > 0 else { return 0.0 }
        return Double(completedCount) / Double(totalCount)
    }

    public var isAllClear: Bool {
        completedCount == totalCount
    }

    public func resetChecklist() {
        for i in 0..<checklistItems.count {
            checklistItems[i].isChecked = false
        }
    }
}
