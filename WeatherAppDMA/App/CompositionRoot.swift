import Foundation

@MainActor
enum CompositionRoot {
    private static let loader = BundleJSONLoader()
    private static let dataSource: WeatherDataSource = LocalWeatherDataSource(loader: loader)
    private static let repository: WeatherRepository = DefaultWeatherRepository(dataSource: dataSource)

    static func makeCitiesView() -> CitiesView {
        let useCase: GetCitiesUseCase = DefaultGetCitiesUseCase(repository: repository)
        let viewModel = CitiesViewModel(getCities: useCase)
        return CitiesView(vm: viewModel, makeWeatherView: makeWeatherView(for:))
    }

    static func makeWeatherView(for city: String) -> WeatherView {
        let useCase: GetWeatherForCityUseCase = DefaultGetWeatherForCityUseCase(repository: repository)
        let viewModel = WeatherViewModel(getWeather: useCase, initialCity: city)
        return WeatherView(vm: viewModel)
    }
}
