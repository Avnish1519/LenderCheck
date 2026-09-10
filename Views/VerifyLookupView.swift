//
//  VerifyLookupView.swift
//  LenderCheck
//

import SwiftUI

public struct VerifyLookupView: View {
    @StateObject private var viewModel = LenderLookupViewModel()

    public init() {}

    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Search Bar Box
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                            .font(.system(size: 16, weight: .medium))

                        TextField("Search bank, NBFC, or loan app...", text: $viewModel.searchQuery)
                            .font(.system(size: 16))
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)

                        if !viewModel.searchQuery.isEmpty {
                            Button(action: { viewModel.searchQuery = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 16))
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color(.separator).opacity(0.3), lineWidth: 0.8)
                    )
                    .padding(.horizontal)

                    // Horizontal Category Filter Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(LenderCategory.allCases) { category in
                                let isSelected = viewModel.selectedCategory == category
                                Button(action: {
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        viewModel.selectCategory(category)
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        if category == .flagged {
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .font(.caption2)
                                        }
                                        Text(category.rawValue)
                                            .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        isSelected
                                            ? (category == .flagged ? AppTheme.dangerRed : AppTheme.primary)
                                            : Color(.secondarySystemGroupedBackground)
                                    )
                                    .foregroundColor(isSelected ? .white : .primary)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(Color(.separator).opacity(isSelected ? 0 : 0.4), lineWidth: 0.8)
                                    )
                                    .shadow(color: isSelected ? (category == .flagged ? AppTheme.dangerRed.opacity(0.2) : AppTheme.primary.opacity(0.2)) : Color.clear, radius: 4, y: 2)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Popular Searches Chips
                    if viewModel.searchQuery.isEmpty && !viewModel.recentSearches.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("QUICK LOOKUP")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.secondary)
                                .tracking(0.5)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(viewModel.recentSearches, id: \.self) { term in
                                        Button(action: {
                                            withAnimation {
                                                viewModel.useRecentSearch(term)
                                            }
                                        }) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "arrow.up.left")
                                                    .font(.system(size: 10, weight: .bold))
                                                    .foregroundColor(AppTheme.primary)
                                                Text(term)
                                                    .font(.system(size: 12, weight: .medium))
                                                    .foregroundColor(.primary)
                                            }
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color(.secondarySystemGroupedBackground))
                                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                    .stroke(Color(.separator).opacity(0.3), lineWidth: 0.6)
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    // Directory Results List
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(viewModel.searchQuery.isEmpty ? "All Registered Entities" : "Results")
                                .font(.system(.headline, design: .default, weight: .bold))

                            Spacer()

                            Text("\(viewModel.searchResults.count) entities")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)

                        if viewModel.searchResults.isEmpty {
                            // Unregistered Entity Warning Box
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(AppTheme.warningAmberBg)
                                        .frame(width: 60, height: 60)
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 28))
                                        .foregroundColor(AppTheme.warningAmber)
                                }

                                VStack(spacing: 4) {
                                    Text("Unregistered Lender")
                                        .font(.headline.bold())
                                    Text("No matching RBI registration found for \"\(viewModel.searchQuery)\". Proceed with high caution before handing over KYC documents or money.")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(2)
                                }
                                .padding(.horizontal)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                            .nativeCardStyle(borderColor: AppTheme.warningAmber.opacity(0.3))
                            .padding(.horizontal)
                        } else {
                            LazyVStack(spacing: 14) {
                                ForEach(viewModel.searchResults) { lender in
                                    LenderCardView(lender: lender) {
                                        viewModel.selectLender(lender)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 12)
            }
            .background(AppTheme.pageBackground.ignoresSafeArea())
            .navigationTitle("Verify Lender")
            .sheet(item: $viewModel.selectedLender) { lender in
                LenderDetailView(lender: lender)
            }
        }
    }
}
