import Foundation
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published private(set) var state: WeatherViewState = .idle
    @Published var query: String = ""

    let initialCity: String?
    private let getWeather: GetWeatherForCityUseCase
    private var currentTask: Task<Void, Never>?

    init(getWeather: GetWeatherForCityUseCase, initialCity: String? = nil) {
        self.getWeather = getWeather
        self.initialCity = initialCity
        if let city = initialCity {
            self.query = city
        }
    }

    func loadInitial() async {
        guard let city = initialCity else { return }
        await fetch(city: city)
    }

    func search() async {
        await fetch(city: query)
    }

    private func fetch(city: String) async {
        currentTask?.cancel()
        let task = Task { [getWeather] in
            let trimmed = city.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else {
                await MainActor.run { self.state = .idle }
                return
            }
            await MainActor.run { self.state = .loading }
            do {
                let weather = try await getWeather.execute(city: trimmed)
                if Task.isCancelled { return }
                await MainActor.run { self.state = .loaded(weather) }
            } catch AppError.cityNotFound(let city) {
                await MainActor.run { self.state = .notFound(city: city) }
            } catch AppError.emptyQuery {
                await MainActor.run { self.state = .idle }
            } catch {
                let message = (error as? LocalizedError)?.errorDescription ?? "Что-то пошло не так."
                await MainActor.run { self.state = .error(message: message) }
            }
        }
        currentTask = task
        await task.value
    }
}
