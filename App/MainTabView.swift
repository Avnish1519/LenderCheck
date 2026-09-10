//
//  MainTabView.swift
//  LenderCheck
//

import SwiftUI

public struct MainTabView: View {
    @State private var selectedTab: Int = 0

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            VerifyLookupView()
                .tabItem {
                    Label("Verify", systemImage: "checkmark.shield.fill")
                }
                .tag(0)

            RiskAuditView()
                .tabItem {
                    Label("Risk Detector", systemImage: "shield.lefthalf.filled")
                }
                .tag(1)

            ScamRadarView()
                .tabItem {
                    Label("Scam Radar", systemImage: "dot.radiowaves.left.and.right")
                }
                .tag(2)

            SafetyHubView()
                .tabItem {
                    Label("Safety Hub", systemImage: "cross.case.fill")
                }
                .tag(3)
        }
        .tint(AppTheme.primary)
    }
}
