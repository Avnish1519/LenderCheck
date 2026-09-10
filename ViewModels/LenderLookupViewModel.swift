//
//  LenderLookupViewModel.swift
//  LenderCheck
//

import Foundation
import Combine

public class LenderLookupViewModel: ObservableObject {
    @Published public var searchQuery: String = ""
    @Published public var selectedCategory: LenderCategory = .all
    @Published public var searchResults: [Lender] = []
    @Published public var selectedLender: Lender? = nil
    @Published public var isSearching: Bool = false
    @Published public var recentSearches: [String] = ["HDFC Bank", "Bajaj Finserv", "QuickCash Pro", "MoneyView"]

    private let registryService: LenderRegistryServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    public init(registryService: LenderRegistryServiceProtocol = LenderRegistryService.shared) {
        self.registryService = registryService
        self.searchResults = registryService.getAllLenders()

        // Bind search query and category filters
        Publishers.CombineLatest($searchQuery, $selectedCategory)
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { [weak self] query, category in
                self?.performSearch(query: query, category: category)
            }
            .store(in: &cancellables)
    }

    public func performSearch(query: String, category: LenderCategory) {
        let results = registryService.searchLenders(query: query, category: category)
        self.searchResults = results
        self.isSearching = !query.trimmingCharacters(in: .whitespaces).isEmpty
    }

    public func selectCategory(_ category: LenderCategory) {
        self.selectedCategory = category
    }

    public func useRecentSearch(_ term: String) {
        self.searchQuery = term
    }

    public func selectLender(_ lender: Lender) {
        self.selectedLender = lender
        if !recentSearches.contains(lender.name) {
            recentSearches.insert(lender.name, at: 0)
            if recentSearches.count > 6 {
                recentSearches.removeLast()
            }
        }
    }

    public var totalVerifiedCount: Int {
        registryService.getAllLenders().filter { $0.isVerified }.count
    }

    public var totalScamFlaggedCount: Int {
        registryService.getAllLenders().filter { $0.verificationStatus == .blacklistedScam }.count
    }
}
