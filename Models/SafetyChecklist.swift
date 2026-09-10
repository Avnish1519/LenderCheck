//
//  SafetyChecklist.swift
//  LenderCheck
//

import Foundation

public struct SafetyChecklistItem: Identifiable, Codable {
    public let id: String
    public let title: String
    public let detail: String
    public let isMandatory: Bool
    public var isChecked: Bool
    public let icon: String

    public init(id: String, title: String, detail: String, isMandatory: Bool = true, isChecked: Bool = false, icon: String) {
        self.id = id
        self.title = title
        self.detail = detail
        self.isMandatory = isMandatory
        self.isChecked = isChecked
        self.icon = icon
    }
}
