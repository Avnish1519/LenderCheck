//
//  LenderCardView.swift
//  LenderCheck
//

import SwiftUI

public struct LenderCardView: View {
    public let lender: Lender
    public let onTap: () -> Void

    public init(lender: Lender, onTap: @escaping () -> Void) {
        self.lender = lender
        self.onTap = onTap
    }

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

    private var iconName: String {
        switch lender.category {
        case .banks: return "building.columns.fill"
        case .nbfcs: return "briefcase.fill"
        case .digitalApps: return "iphone.gen3"
        case .flagged: return "xmark.octagon.fill"
        case .all: return "shield.fill"
        }
    }

    private var iconTint: Color {
        switch lender.category {
        case .banks: return AppTheme.primary
        case .nbfcs: return Color.indigo
        case .digitalApps: return AppTheme.accent
        case .flagged: return AppTheme.dangerRed
        case .all: return AppTheme.primary
        }
    }

    public var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 14) {
                // Top Row: Leading Icon + Title Block + Status Badge
                HStack(alignment: .top, spacing: 12) {
                    // Category Icon Avatar
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(iconTint.opacity(0.12))
                            .frame(width: 44, height: 44)
                        Image(systemName: iconName)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(iconTint)
                    }

                    // Title & Legal Name
                    VStack(alignment: .leading, spacing: 3) {
                        Text(lender.name)
                            .font(.system(.headline, design: .default, weight: .bold))
                            .foregroundColor(.primary)
                            .lineLimit(1)

                        Text(lender.legalEntityName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 4)

                    // Status Badge Pill
                    HStack(spacing: 4) {
                        Image(systemName: lender.verificationStatus.systemIcon)
                            .font(.system(size: 10, weight: .bold))
                        Text(lender.verificationStatus.rawValue)
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(statusBgColor)
                    .foregroundColor(statusColor)
                    .clipShape(Capsule())
                }

                // Middle Info: Metadata Pills
                HStack(spacing: 8) {
                    // Category Tag
                    Text(lender.category.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray6))
                        .foregroundColor(.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))

                    // Registration Number Tag
                    if let reg = lender.regNumber {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.seal")
                                .font(.system(size: 10))
                            Text(reg)
                                .font(.system(size: 11, weight: .medium))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray6))
                        .foregroundColor(.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                        .lineLimit(1)
                    }
                }

                // Red Flags Box (if any)
                if !lender.redFlags.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(lender.redFlags.prefix(2), id: \.self) { flag in
                            HStack(alignment: .top, spacing: 6) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.dangerRed)
                                    .padding(.top, 1)
                                Text(flag)
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.dangerRed)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.dangerRedBg)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                } else if !lender.authorizedAppNames.isEmpty {
                    HStack(spacing: 4) {
                        Text("App:")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                        Text(lender.authorizedAppNames.joined(separator: ", "))
                            .font(.caption)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                    }
                }

                // Footer Row: Registered City & View details link
                HStack {
                    if let hq = lender.headquarters {
                        Label(hq, systemImage: "mappin.and.ellipse")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("Details")
                        .font(.caption.bold())
                        .foregroundColor(AppTheme.primary)
                    Image(systemName: "chevron.right")
                        .font(.caption2.bold())
                        .foregroundColor(AppTheme.primary)
                }
            }
            .nativeCardStyle(borderColor: lender.verificationStatus == .blacklistedScam ? AppTheme.dangerRed.opacity(0.3) : nil)
        }
        .buttonStyle(.plain)
    }
}
