//
//  SafetyHubView.swift
//  LenderCheck
//

import SwiftUI

public struct SafetyHubView: View {
    @StateObject private var viewModel = SafetyHubViewModel()

    public init() {}

    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Emergency Helpline Hero Card (1930 & Portal)
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 36, height: 36)
                                Image(systemName: "phone.badge.checkmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Emergency Cybercrime Helpline")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Government of India (MHA)")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }

                        Text("If you are being harassed or lost money to a fake loan app, report within the golden hour to freeze fraudulent transactions.")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(2)

                        HStack(spacing: 10) {
                            if let phoneUrl = URL(string: "tel://1930") {
                                Link(destination: phoneUrl) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "phone.fill")
                                            .font(.caption.bold())
                                        Text("Call 1930")
                                            .font(.subheadline.bold())
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                                    .foregroundColor(AppTheme.dangerRed)
                                    .clipShape(Capsule())
                                    .shadow(color: Color.black.opacity(0.1), radius: 4, y: 2)
                                }
                            }

                            if let portalUrl = URL(string: "https://cybercrime.gov.in") {
                                Link(destination: portalUrl) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "safari.fill")
                                            .font(.caption.bold())
                                        Text("cybercrime.gov.in")
                                            .font(.subheadline.bold())
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color.white.opacity(0.2))
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                                }
                            }
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            colors: [Color(red: 0.88, green: 0.18, blue: 0.22), Color(red: 0.70, green: 0.10, blue: 0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
                    .shadow(color: AppTheme.dangerRed.opacity(0.25), radius: 10, y: 4)
                    .padding(.horizontal)

                    // Pre-Disbursement Safety Checklist Card
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("PRE-DISBURSEMENT CHECKLIST")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.secondary)
                                    .tracking(0.5)
                                Text("Complete before signing or accepting money")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button("Reset") {
                                viewModel.resetChecklist()
                            }
                            .font(.caption.bold())
                            .foregroundColor(AppTheme.primary)
                        }

                        // Progress Bar
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("\(viewModel.completedCount) of \(viewModel.totalCount) Verified")
                                    .font(.footnote.bold())
                                    .foregroundColor(viewModel.isAllClear ? AppTheme.safeGreen : AppTheme.primary)
                                Spacer()
                                Text("\(Int(viewModel.progressPercentage * 100))%")
                                    .font(.footnote.bold())
                                    .foregroundColor(.secondary)
                            }

                            ProgressView(value: viewModel.progressPercentage)
                                .tint(viewModel.isAllClear ? AppTheme.safeGreen : AppTheme.primary)
                        }

                        Divider()

                        // Checklist Items
                        VStack(spacing: 10) {
                            ForEach(viewModel.checklistItems) { item in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        viewModel.toggleChecklist(id: item.id)
                                    }
                                }) {
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(item.isChecked ? AppTheme.safeGreen : Color(.systemGray4))
                                            .font(.system(size: 22))
                                            .padding(.top, 1)

                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(item.title)
                                                .font(.subheadline.bold())
                                                .foregroundColor(item.isChecked ? .secondary : .primary)
                                                .strikethrough(item.isChecked, color: .secondary)

                                            Text(item.detail)
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                                .lineSpacing(2)
                                        }
                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(item.isChecked ? AppTheme.safeGreenBg : Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .nativeCardStyle()
                    .padding(.horizontal)

                    // 4 Golden Rules Section
                    VStack(alignment: .leading, spacing: 14) {
                        Text("4 GOLDEN RULES OF BORROWING")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)

                        VStack(spacing: 12) {
                            GoldenRuleCard(
                                number: "1",
                                title: "Zero Upfront Payments",
                                description: "Legitimate lenders never ask for advance fees or GST before loan disbursal. Charges are deducted only from the approved loan.",
                                color: AppTheme.dangerRed
                            )

                            GoldenRuleCard(
                                number: "2",
                                title: "Deny Contact Book Access",
                                description: "RBI guidelines prohibit lending apps from accessing your phone contacts, photo gallery, or call logs.",
                                color: AppTheme.warningAmber
                            )

                            GoldenRuleCard(
                                number: "3",
                                title: "Demand a Key Fact Statement (KFS)",
                                description: "The lender must provide an itemized KFS sheet specifying APR, total interest, and recovery agent names.",
                                color: AppTheme.primary
                            )

                            GoldenRuleCard(
                                number: "4",
                                title: "Verify on RBI Sachet Portal",
                                description: "Cross-check sachet.rbi.org.in to confirm if an entity is registered under RBI regulation.",
                                color: AppTheme.safeGreen
                            )
                        }
                    }
                    .nativeCardStyle()
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)
            }
            .background(AppTheme.pageBackground.ignoresSafeArea())
            .navigationTitle("Safety Hub")
        }
    }
}

private struct GoldenRuleCard: View {
    let number: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(color)
                .clipShape(Circle())
                .padding(.top, 1)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineSpacing(2)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
