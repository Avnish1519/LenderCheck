//
//  RiskAuditViewModel.swift
//  LenderCheck
//

import Foundation
import Combine

public enum RiskAuditMode: String, CaseIterable, Identifiable {
    case diagnosticQuiz = "5-Step Risk Diagnostic"
    case smsScanner = "SMS & Message Scanner"

    public var id: String { rawValue }
}

public class RiskAuditViewModel: ObservableObject {
    @Published public var selectedMode: RiskAuditMode = .diagnosticQuiz

    // Diagnostic Questionnaire State
    @Published public var questions: [RiskQuestion] = []
    @Published public var selectedOptions: [Int: String] = [:] // Question ID -> Option ID
    @Published public var assessmentResult: RiskAssessmentResult? = nil
    @Published public var currentQuestionIndex: Int = 0

    // SMS & Message Scanner State
    @Published public var textToScan: String = ""
    @Published public var textScanResult: TextScanResult? = nil
    @Published public var isScanningText: Bool = false

    private let engine: RiskAssessmentEngineProtocol

    public init(engine: RiskAssessmentEngineProtocol = RiskAssessmentEngine.shared) {
        self.engine = engine
        self.questions = engine.getDiagnosticQuestions()
        // Initialize default answers to safe options to provide instant preview
        for q in questions {
            if let first = q.options.first {
                selectedOptions[q.id] = first.id
            }
        }
        recalculateScore()
    }

    public func selectOption(questionId: Int, optionId: String) {
        selectedOptions[questionId] = optionId
        recalculateScore()
    }

    public func recalculateScore() {
        let optionIds = Array(selectedOptions.values)
        assessmentResult = engine.calculateRisk(selectedOptionIds: optionIds)
    }

    public func resetDiagnostic() {
        selectedOptions.removeAll()
        for q in questions {
            if let first = q.options.first {
                selectedOptions[q.id] = first.id
            }
        }
        currentQuestionIndex = 0
        recalculateScore()
    }

    public func scanPastedText() {
        guard !textToScan.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isScanningText = true
        // Simulate real-time analyzer feel
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            self.textScanResult = self.engine.analyzeTextOrSMS(content: self.textToScan)
            self.isScanningText = false
        }
    }

    public func loadSampleScamSMS() {
        textToScan = "Congratulations! Your instant personal loan of Rs 3,50,000 is APPROVED without CIBIL. Pay Rs 1,499 refundable GST file charge to release funds within 10 mins. Send payment screenshot to WhatsApp wa.me/919988776655. Download APK: bit.ly/easy-rupee-apk"
        scanPastedText()
    }

    public func loadSampleSafeSMS() {
        textToScan = "Dear Customer, your personal loan application with HDFC Bank (Ref: PL882910) has been approved in principle. Track status on official netbanking or visit hdfcbank.com. No advance fee is required."
        scanPastedText()
    }
}
