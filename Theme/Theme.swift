//
//  Theme.swift
//  LenderCheck
//

import SwiftUI

public enum AppTheme {
    // Brand Colors
    public static let primary = Color(red: 0.10, green: 0.35, blue: 0.85) // Trust Royal Blue
    public static let primaryDark = Color(red: 0.06, green: 0.22, blue: 0.58)
    public static let accent = Color(red: 0.05, green: 0.65, blue: 0.88) // Electric Cyan

    // Status Colors
    public static let safeGreen = Color(red: 0.12, green: 0.68, blue: 0.42)
    public static let safeGreenBg = Color(red: 0.12, green: 0.68, blue: 0.42).opacity(0.10)

    public static let warningAmber = Color(red: 0.95, green: 0.58, blue: 0.10)
    public static let warningAmberBg = Color(red: 0.95, green: 0.58, blue: 0.10).opacity(0.12)

    public static let dangerRed = Color(red: 0.92, green: 0.24, blue: 0.28)
    public static let dangerRedBg = Color(red: 0.92, green: 0.24, blue: 0.28).opacity(0.10)

    // Backgrounds
    public static let pageBackground = Color(.systemGroupedBackground)
    public static let cardBackground = Color(.secondarySystemGroupedBackground)
    public static let chipBackground = Color(.tertiarySystemGroupedBackground)

    // Card Styling
    public static let cornerRadius: CGFloat = 16
    public static let smallRadius: CGFloat = 10

    // Shadows
    public static let cardShadow = Color.black.opacity(0.04)
}

// Reusable card container modifier for iOS native feel
public struct NativeCardModifier: ViewModifier {
    public var borderColor: Color? = nil

    public func body(content: Content) -> some View {
        content
            .padding(18)
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous)
                    .stroke(borderColor ?? Color(.separator).opacity(0.3), lineWidth: 0.8)
            )
            .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 3)
    }
}

public extension View {
    func nativeCardStyle(borderColor: Color? = nil) -> some View {
        self.modifier(NativeCardModifier(borderColor: borderColor))
    }
}
