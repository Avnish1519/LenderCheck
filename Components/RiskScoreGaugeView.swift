//
//  RiskScoreGaugeView.swift
//  LenderCheck
//

import SwiftUI

public struct RiskScoreGaugeView: View {
    public let score: Int // 0 to 100
    public let title: String
    public let subtitle: String

    public init(score: Int, title: String = "Trust & Safety Score", subtitle: String = "") {
        self.score = score
        self.title = title
        self.subtitle = subtitle
    }

    private var scoreColor: Color {
        if score >= 80 {
            return AppTheme.safeGreen
        } else if score >= 50 {
            return AppTheme.warningAmber
        } else {
            return AppTheme.dangerRed
        }
    }

    private var statusText: String {
        if score >= 80 {
            return "VERIFIED SAFE"
        } else if score >= 50 {
            return "MODERATE CAUTION"
        } else {
            return "HIGH SCAM RISK"
        }
    }

    private var statusIcon: String {
        if score >= 80 {
            return "checkmark.shield.fill"
        } else if score >= 50 {
            return "exclamationmark.triangle.fill"
        } else {
            return "xmark.octagon.fill"
        }
    }

    public var body: some View {
        VStack(spacing: 16) {
            ZStack {
                // Background Track
                Circle()
                    .stroke(
                        Color(.systemGray5),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 130, height: 130)

                // Animated Progress Ring
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(max(Double(score) / 100.0, 0.03), 1.0)))
                    .stroke(
                        LinearGradient(
                            colors: score >= 80 ? [AppTheme.safeGreen, Color.mint] : (score >= 50 ? [AppTheme.warningAmber, Color.yellow] : [AppTheme.dangerRed, Color.orange]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: 130, height: 130)
                    .animation(.spring(response: 0.6, dampingFraction: 0.75), value: score)

                // Center Score Display
                VStack(spacing: 0) {
                    Text("\(score)")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text("OUT OF 100")
                        .font(.system(size: 9, weight: .semibold, design: .rounded))
                        .foregroundColor(.secondary)
                        .tracking(0.5)
                }
            }

            VStack(spacing: 6) {
                // Status Badge
                HStack(spacing: 6) {
                    Image(systemName: statusIcon)
                        .font(.caption.bold())
                    Text(statusText)
                        .font(.caption.bold())
                        .tracking(0.3)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(scoreColor.opacity(0.12))
                .foregroundColor(scoreColor)
                .clipShape(Capsule())

                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}
