import Foundation

struct RemoteWeatherDataSource: WeatherDataSource {
    func loadWeather(for city: String) async throws -> WeatherDTO {
        throw AppError.notImplemented
    }

    func loadCities() async throws -> [CityDTO] {
        throw AppError.notImplemented
    }
}
