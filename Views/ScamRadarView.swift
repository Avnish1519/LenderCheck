//
//  ScamRadarView.swift
//  LenderCheck
//

import SwiftUI

public struct ScamRadarView: View {
    @StateObject private var viewModel = ScamRadarViewModel()
    @State private var selectedTabSection = 0 // 0: Live Reports, 1: Modus Operandi

    public init() {}

    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Top Section Selector
                    Picker("Radar Section", selection: $selectedTabSection) {
                        Text("Live Reports").tag(0)
                        Text("Scam Patterns").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    if selectedTabSection == 0 {
                        liveReportsSection
                    } else {
                        modusOperandiSection
                    }
                }
                .padding(.vertical, 12)
            }
            .background(AppTheme.pageBackground.ignoresSafeArea())
            .navigationTitle("Scam Radar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showingReportSheet = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                            Text("Report")
                        }
                        .font(.subheadline.bold())
                        .foregroundColor(AppTheme.dangerRed)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingReportSheet) {
                ReportScamSheet(viewModel: viewModel)
            }
        }
    }

    // MARK: - Live Reports Section
    private var liveReportsSection: some View {
        VStack(spacing: 16) {
            // Search Scam Input
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 15))
                TextField("Search flagged app or entity...", text: $viewModel.searchScamQuery)
                    .font(.system(size: 15))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color(.separator).opacity(0.3), lineWidth: 0.8)
            )
            .padding(.horizontal)

            // Reports Count Header
            HStack {
                Text("FLAGGED INCIDENTS (\(viewModel.filteredReports.count))")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                Spacer()
            }
            .padding(.horizontal)

            // Reports List
            LazyVStack(spacing: 14) {
                ForEach(viewModel.filteredReports) { report in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(report.appName)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("Claimed: \(report.lenderOrCompanyClaimed)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(report.status)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(AppTheme.dangerRed)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(AppTheme.dangerRedBg)
                                .clipShape(Capsule())
                        }

                        // Channels Used Tags
                        HStack(spacing: 6) {
                            Text(report.scamCategory)
                                .font(.system(size: 11, weight: .medium))
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(Color(.systemGray6))
                                .foregroundColor(.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))

                            ForEach(report.contactChannelsUsed, id: \.self) { ch in
                                Text(ch)
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 3)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            }
                        }

                        Text(report.description)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineSpacing(2)

                        HStack {
                            Label("\(report.reportCount) reports", systemImage: "person.2.fill")
                                .font(.caption2)
                                .foregroundColor(.secondary)

                            Spacer()

                            Text(report.dateReported, style: .date)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .nativeCardStyle(borderColor: AppTheme.dangerRed.opacity(0.2))
                    .padding(.horizontal)
                }
            }
        }
    }

    // MARK: - Modus Operandi Section
    private var modusOperandiSection: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.modusOperandiList) { mo in
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(AppTheme.warningAmberBg)
                                .frame(width: 32, height: 32)
                            Image(systemName: mo.icon)
                                .foregroundColor(AppTheme.warningAmber)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        Text(mo.title)
                            .font(.headline)
                    }

                    Text(mo.summary)
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    Divider()

                    VStack(alignment: .leading, spacing: 4) {
                        Text("HOW THE TRAP WORKS")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)
                        Text(mo.howItWorks)
                            .font(.footnote)
                            .foregroundColor(.primary)
                            .lineSpacing(2)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("HOW TO SPOT")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)

                        ForEach(mo.howToSpot, id: \.self) { spot in
                            HStack(alignment: .top, spacing: 6) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(AppTheme.warningAmber)
                                    .padding(.top, 2)
                                Text(spot)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("ACTION IF TRAPPED")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(AppTheme.dangerRed)
                            .tracking(0.5)
                        Text(mo.actionIfTrapped)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.dangerRedBg)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                .nativeCardStyle()
                .padding(.horizontal)
            }
        }
    }
}
