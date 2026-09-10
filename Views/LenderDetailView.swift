//
//  LenderDetailView.swift
//  LenderCheck
//

import SwiftUI

public struct LenderDetailView: View {
    public let lender: Lender
    @Environment(\.dismiss) private var dismiss

    private var statusColor: Color {
        switch lender.verificationStatus {
        case .verifiedOfficial, .regulatedNBFC, .authorizedPartner:
            return AppTheme.safeGreen
        case .cautionUnverified:
            return AppTheme.warningAmber
        case .blacklistedScam:
            return AppTheme.dangerRed
        }
    }

    private var statusBgColor: Color {
        switch lender.verificationStatus {
        case .verifiedOfficial, .regulatedNBFC, .authorizedPartner:
            return AppTheme.safeGreenBg
        case .cautionUnverified:
            return AppTheme.warningAmberBg
        case .blacklistedScam:
            return AppTheme.dangerRedBg
        }
    }

    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Top Hero Status Card
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(statusBgColor)
                                .frame(width: 72, height: 72)
                            Image(systemName: lender.verificationStatus.systemIcon)
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(statusColor)
                        }

                        VStack(spacing: 4) {
                            Text(lender.name)
                                .font(.title2.bold())
                                .multilineTextAlignment(.center)

                            Text(lender.legalEntityName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        HStack(spacing: 6) {
                            Image(systemName: lender.verificationStatus.systemIcon)
                                .font(.caption.bold())
                            Text(lender.verificationStatus.rawValue)
                                .font(.caption.bold())
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(statusBgColor)
                        .foregroundColor(statusColor)
                        .clipShape(Capsule())
                    }
                    .frame(maxWidth: .infinity)
                    .nativeCardStyle(borderColor: lender.verificationStatus == .blacklistedScam ? AppTheme.dangerRed.opacity(0.3) : nil)
                    .padding(.horizontal)

                    // Red Flags Alert (if blacklisted)
                    if !lender.redFlags.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(AppTheme.dangerRed)
                                    .font(.headline)
                                Text("Known Red Flags")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.dangerRed)
                            }

                            Divider()

                            ForEach(lender.redFlags, id: \.self) { flag in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.subheadline)
                                        .foregroundColor(AppTheme.dangerRed)
                                        .padding(.top, 1)
                                    Text(flag)
                                        .font(.footnote)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .nativeCardStyle(borderColor: AppTheme.dangerRed.opacity(0.3))
                        .padding(.horizontal)
                    }

                    // Regulatory Credentials Section
                    VStack(alignment: .leading, spacing: 14) {
                        Text("REGULATORY CREDENTIALS")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)

                        VStack(spacing: 12) {
                            DetailRow(title: "Regulatory Body", value: lender.regulatoryBody, icon: "building.columns.fill", iconColor: AppTheme.primary)

                            Divider()

                            if let reg = lender.regNumber {
                                DetailRow(title: "License / Registration No.", value: reg, icon: "checkmark.seal.fill", iconColor: AppTheme.safeGreen)
                            } else {
                                DetailRow(title: "Registration Status", value: "No Valid License Found", icon: "xmark.octagon.fill", iconColor: AppTheme.dangerRed, isWarning: true)
                            }

                            Divider()

                            DetailRow(title: "Entity Category", value: lender.type, icon: "tag.fill", iconColor: Color.indigo)

                            if let hq = lender.headquarters {
                                Divider()
                                DetailRow(title: "Registered Location", value: hq, icon: "mappin.circle.fill", iconColor: Color.orange)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .nativeCardStyle()
                    .padding(.horizontal)

                    // Authorized Apps Section
                    if !lender.authorizedAppNames.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(lender.isVerified ? "AUTHORIZED DIGITAL APPS" : "ASSOCIATED APP NAMES")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.secondary)
                                .tracking(0.5)

                            VStack(spacing: 8) {
                                ForEach(lender.authorizedAppNames, id: \.self) { appName in
                                    HStack(spacing: 10) {
                                        Image(systemName: lender.isVerified ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                            .foregroundColor(lender.isVerified ? AppTheme.safeGreen : AppTheme.dangerRed)
                                            .font(.subheadline)
                                        Text(appName)
                                            .font(.subheadline.bold())
                                            .foregroundColor(.primary)
                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .nativeCardStyle()
                        .padding(.horizontal)
                    }

                    // Official Contact Section (if verified)
                    if lender.isVerified {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("OFFICIAL CONTACT CHANNELS")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.secondary)
                                .tracking(0.5)

                            VStack(spacing: 12) {
                                if let website = lender.officialWebsite, let url = URL(string: website) {
                                    Link(destination: url) {
                                        HStack(spacing: 10) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                    .fill(AppTheme.primary.opacity(0.12))
                                                    .frame(width: 32, height: 32)
                                                Image(systemName: "globe")
                                                    .foregroundColor(AppTheme.primary)
                                                    .font(.system(size: 14, weight: .medium))
                                            }
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("Official Domain")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                Text(website)
                                                    .font(.subheadline.bold())
                                                    .foregroundColor(AppTheme.primary)
                                            }
                                            Spacer()
                                            Image(systemName: "arrow.up.right")
                                                .font(.caption.bold())
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }

                                if let phone = lender.customerCarePhone {
                                    Divider()
                                    DetailRow(title: "Customer Support", value: phone, icon: "phone.fill", iconColor: AppTheme.safeGreen)
                                }

                                if let email = lender.officialGrievanceEmail {
                                    Divider()
                                    DetailRow(title: "Grievance Officer", value: email, icon: "envelope.fill", iconColor: Color.blue)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .nativeCardStyle()
                        .padding(.horizontal)
                    }

                    // Description / About Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ABOUT")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)

                        Text(lender.description)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .lineSpacing(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .nativeCardStyle()
                    .padding(.horizontal)
                }
                .padding(.vertical, 16)
            }
            .background(AppTheme.pageBackground.ignoresSafeArea())
            .navigationTitle("Entity Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.body.bold())
                    .foregroundColor(AppTheme.primary)
                }
            }
        }
    }
}

private struct DetailRow: View {
    let title: String
    let value: String
    let icon: String
    var iconColor: Color = AppTheme.primary
    var isWarning: Bool = false

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline.bold())
                    .foregroundColor(isWarning ? AppTheme.dangerRed : .primary)
            }
            Spacer()
        }
    }
}
