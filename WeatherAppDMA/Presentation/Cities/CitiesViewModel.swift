import Foundation
import Combine

@MainActor
final class CitiesViewModel: ObservableObject {
    @Published private(set) var state: CitiesViewState = .loading
    @Published var query: String = ""

    private let getCities: GetCitiesUseCase

    init(getCities: GetCitiesUseCase) {
        self.getCities = getCities
    }

    var filteredCities: [CitySummary] {
        guard case .loaded(let cities) = state else { return [] }
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return cities }
        return cities.filter {
            $0.name.range(of: trimmed, options: .caseInsensitive) != nil
        }
    }

    func load() async {
        state = .loading
        do {
            let cities = try await getCities.execute()
            state = .loaded(cities)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? "Что-то пошло не так."
            state = .error(message: message)
        }
    }
}
