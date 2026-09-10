//
//  ReportScamSheet.swift
//  LenderCheck
//

import SwiftUI

public struct ReportScamSheet: View {
    @ObservedObject var viewModel: ScamRadarViewModel
    @Environment(\.dismiss) private var dismiss

    let categories = [
        "Extortion / Harassment",
        "Upfront Processing Fee Fraud",
        "7-Day Fake Loan",
        "Identity Theft",
        "Fake Approval SMS / WhatsApp",
        "Malicious Shadow APK"
    ]

    let channelOptions = ["WhatsApp", "Direct APK", "Telegram", "SMS", "Social Media Ad", "Web Link"]

    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("SUSPECT APP OR LENDER")) {
                    TextField("App Name (e.g. QuickCash VIP)", text: $viewModel.newAppName)
                    TextField("Claimed Entity (Optional)", text: $viewModel.newCompanyClaimed)

                    Picker("Scam Type", selection: $viewModel.newCategory) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                }

                Section(header: Text("COMMUNICATION CHANNELS")) {
                    ForEach(channelOptions, id: \.self) { channel in
                        let isSelected = viewModel.selectedChannels.contains(channel)
                        Button(action: {
                            if isSelected {
                                viewModel.selectedChannels.remove(channel)
                            } else {
                                viewModel.selectedChannels.insert(channel)
                            }
                        }) {
                            HStack {
                                Text(channel)
                                    .foregroundColor(.primary)
                                Spacer()
                                if isSelected {
                                    Image(systemName: "checkmark")
                                        .font(.caption.bold())
                                        .foregroundColor(AppTheme.primary)
                                }
                            }
                        }
                    }
                }

                Section(header: Text("INCIDENT DESCRIPTION")) {
                    TextEditor(text: $viewModel.newDescription)
                        .frame(minHeight: 90)
                }

                Section {
                    Button(action: {
                        viewModel.submitNewReport()
                        dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Text("Submit Incident Report")
                                .font(.body.bold())
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .listRowBackground(viewModel.newAppName.isEmpty ? Color.gray.opacity(0.4) : AppTheme.dangerRed)
                    .disabled(viewModel.newAppName.isEmpty)
                }
            }
            .navigationTitle("Report Scam App")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primary)
                }
            }
        }
    }
}
