//
//  RiskAuditView.swift
//  LenderCheck
//

import SwiftUI

public struct RiskAuditView: View {
    @StateObject private var viewModel = RiskAuditViewModel()

    public init() {}

    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Segmented Mode Selector
                    Picker("Mode", selection: $viewModel.selectedMode) {
                        ForEach(RiskAuditMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    if viewModel.selectedMode == .diagnosticQuiz {
                        diagnosticQuizView
                    } else {
                        smsScannerView
                    }
                }
                .padding(.vertical, 12)
            }
            .background(AppTheme.pageBackground.ignoresSafeArea())
            .navigationTitle("Risk Detector")
        }
    }

    // MARK: - 5-Step Diagnostic Quiz View
    private var diagnosticQuizView: some View {
        VStack(spacing: 20) {
            // Live Safety Score Card
            if let result = viewModel.assessmentResult {
                VStack(spacing: 16) {
                    RiskScoreGaugeView(
                        score: result.safetyScore,
                        title: "Calculated Safety Score",
                        subtitle: "Answers are analyzed against RBI lending guidelines in real time."
                    )

                    // Detected Red Flags Callout
                    if !result.detectedRedFlags.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(AppTheme.dangerRed)
                                    .font(.subheadline)
                                Text("Scam Markers Detected (\(result.detectedRedFlags.count))")
                                    .font(.subheadline.bold())
                                    .foregroundColor(AppTheme.dangerRed)
                            }

                            Divider()

                            ForEach(result.detectedRedFlags, id: \.self) { flag in
                                HStack(alignment: .top, spacing: 6) {
                                    Text("•")
                                        .foregroundColor(AppTheme.dangerRed)
                                        .bold()
                                    Text(flag)
                                        .font(.footnote)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(AppTheme.dangerRedBg)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    // Actionable Recommendations
                    VStack(alignment: .leading, spacing: 8) {
                        Text("RECOMMENDED ACTIONS")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)

                        ForEach(result.recommendations, id: \.self) { rec in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: result.safetyScore >= 80 ? "checkmark.circle.fill" : "hand.raised.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(result.safetyScore >= 80 ? AppTheme.safeGreen : AppTheme.warningAmber)
                                    .padding(.top, 2)
                                Text(rec)
                                    .font(.footnote)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .nativeCardStyle()
                .padding(.horizontal)
            }

            // Questions List
            VStack(spacing: 16) {
                ForEach(viewModel.questions) { question in
                    VStack(alignment: .leading, spacing: 14) {
                        // Question Header
                        HStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(AppTheme.primary.opacity(0.12))
                                    .frame(width: 30, height: 30)
                                Image(systemName: question.icon)
                                    .foregroundColor(AppTheme.primary)
                                    .font(.system(size: 14, weight: .semibold))
                            }

                            Text("Q\(question.id). \(question.title)")
                                .font(.system(.subheadline, design: .default, weight: .bold))
                                .foregroundColor(.primary)
                        }

                        Text(question.subtitle)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineSpacing(2)

                        // Radio Options
                        VStack(spacing: 10) {
                            ForEach(question.options) { option in
                                let isSelected = viewModel.selectedOptions[question.id] == option.id
                                Button(action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        viewModel.selectOption(questionId: question.id, optionId: option.id)
                                    }
                                }) {
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(isSelected ? (option.riskPenalty > 0 ? AppTheme.dangerRed : AppTheme.safeGreen) : Color(.systemGray4))
                                            .font(.system(size: 20))
                                            .padding(.top, 1)

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(option.text)
                                                .font(.subheadline)
                                                .foregroundColor(isSelected ? .primary : .secondary)
                                                .multilineTextAlignment(.leading)

                                            if option.riskPenalty > 0 && isSelected {
                                                Text("⚠️ Penalty: -\(option.riskPenalty) Safety Points")
                                                    .font(.caption2.bold())
                                                    .foregroundColor(AppTheme.dangerRed)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(
                                        isSelected
                                            ? (option.riskPenalty > 0 ? AppTheme.dangerRedBg : AppTheme.safeGreenBg)
                                            : Color(.systemGray6)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .stroke(
                                                isSelected
                                                    ? (option.riskPenalty > 0 ? AppTheme.dangerRed.opacity(0.4) : AppTheme.safeGreen.opacity(0.4))
                                                    : Color.clear,
                                                lineWidth: 1.2
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .nativeCardStyle()
                    .padding(.horizontal)
                }
            }

            // Reset Button
            Button(action: {
                withAnimation {
                    viewModel.resetDiagnostic()
                }
            }) {
                Label("Reset Assessment", systemImage: "arrow.counterclockwise")
                    .font(.subheadline.bold())
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            }
        }
    }

    // MARK: - SMS & Message Scanner View
    private var smsScannerView: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text("PASTE MESSAGE OR SANCTION LETTER")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)

                TextEditor(text: $viewModel.textToScan)
                    .frame(minHeight: 110)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color(.separator).opacity(0.3), lineWidth: 0.8)
                    )

                HStack(spacing: 8) {
                    Button("Try Scam Sample") {
                        viewModel.loadSampleScamSMS()
                    }
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(AppTheme.dangerRedBg)
                    .foregroundColor(AppTheme.dangerRed)
                    .clipShape(Capsule())

                    Button("Try Safe Sample") {
                        viewModel.loadSampleSafeSMS()
                    }
                    .font(.caption.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(AppTheme.safeGreenBg)
                    .foregroundColor(AppTheme.safeGreen)
                    .clipShape(Capsule())
                }

                Button(action: {
                    viewModel.scanPastedText()
                }) {
                    HStack {
                        if viewModel.isScanningText {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "text.magnifyingglass")
                            Text("Analyze Text")
                                .font(.system(size: 15, weight: .bold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(viewModel.textToScan.isEmpty ? Color.gray.opacity(0.4) : AppTheme.primary)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .disabled(viewModel.textToScan.isEmpty || viewModel.isScanningText)
            }
            .nativeCardStyle()
            .padding(.horizontal)

            // Analysis Result Card
            if let result = viewModel.textScanResult {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(result.isHighRisk ? AppTheme.dangerRedBg : AppTheme.safeGreenBg)
                                .frame(width: 40, height: 40)
                            Image(systemName: result.isHighRisk ? "exclamationmark.triangle.fill" : "checkmark.shield.fill")
                                .foregroundColor(result.isHighRisk ? AppTheme.dangerRed : AppTheme.safeGreen)
                                .font(.system(size: 20))
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(result.isHighRisk ? "High Scam Probability" : "Low Risk Content")
                                .font(.headline)
                                .foregroundColor(result.isHighRisk ? AppTheme.dangerRed : AppTheme.safeGreen)
                            Text("Risk Score: \(result.scamProbabilityScore)%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }

                    Text(result.summary)
                        .font(.footnote)
                        .foregroundColor(.primary)
                        .lineSpacing(2)

                    if !result.detectedKeywords.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("FLAGGED KEYWORDS")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.secondary)
                                .tracking(0.5)

                            ForEach(result.detectedKeywords, id: \.self) { kw in
                                HStack(spacing: 6) {
                                    Image(systemName: "xmark.octagon.fill")
                                        .foregroundColor(AppTheme.dangerRed)
                                        .font(.caption2)
                                    Text(kw)
                                        .font(.caption.bold())
                                        .foregroundColor(AppTheme.dangerRed)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(AppTheme.dangerRedBg)
                                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("GUIDANCE")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)

                        ForEach(result.advice, id: \.self) { adv in
                            HStack(alignment: .top, spacing: 6) {
                                Image(systemName: "shield.fill")
                                    .font(.caption2)
                                    .foregroundColor(AppTheme.primary)
                                    .padding(.top, 2)
                                Text(adv)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .nativeCardStyle(borderColor: result.isHighRisk ? AppTheme.dangerRed.opacity(0.3) : AppTheme.safeGreen.opacity(0.3))
                .padding(.horizontal)
            }
        }
    }
}
