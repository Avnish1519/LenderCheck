//
//  ScamRadarViewModel.swift
//  LenderCheck
//

import Foundation
import Combine

public class ScamRadarViewModel: ObservableObject {
    @Published public var liveReports: [ScamReport] = []
    @Published public var modusOperandiList: [ScamModusOperandi] = []
    @Published public var filterCategory: String = "All"
    @Published public var searchScamQuery: String = ""

    // Report Sheet form state
    @Published public var showingReportSheet: Bool = false
    @Published public var newAppName: String = ""
    @Published public var newCompanyClaimed: String = ""
    @Published public var newCategory: String = "Extortion / Harassment"
    @Published public var newDescription: String = ""
    @Published public var selectedChannels: Set<String> = ["Direct APK", "WhatsApp"]
    @Published public var reportSubmittedSuccess: Bool = false

    private let radarService: ScamRadarServiceProtocol

    public init(radarService: ScamRadarServiceProtocol = ScamRadarService.shared) {
        self.radarService = radarService
        self.liveReports = radarService.getLiveScamReports()
        self.modusOperandiList = radarService.getModusOperandiList()
    }

    public var filteredReports: [ScamReport] {
        var list = liveReports
        if filterCategory != "All" {
            list = list.filter { $0.scamCategory.localizedCaseInsensitiveContains(filterCategory) }
        }
        if !searchScamQuery.trimmingCharacters(in: .whitespaces).isEmpty {
            let q = searchScamQuery.lowercased()
            list = list.filter { $0.appName.lowercased().contains(q) || $0.lenderOrCompanyClaimed.lowercased().contains(q) }
        }
        return list
    }

    public func submitNewReport() {
        guard !newAppName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let report = radarService.submitReport(
            appName: newAppName,
            companyClaimed: newCompanyClaimed.isEmpty ? "Unknown" : newCompanyClaimed,
            category: newCategory,
            description: newDescription,
            channels: Array(selectedChannels)
        )
        liveReports.insert(report, at: 0)
        reportSubmittedSuccess = true
        resetForm()
    }

    public func resetForm() {
        newAppName = ""
        newCompanyClaimed = ""
        newDescription = ""
        selectedChannels = ["Direct APK", "WhatsApp"]
    }
}
