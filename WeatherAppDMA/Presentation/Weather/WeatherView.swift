import SwiftUI

struct WeatherView: View {
    @StateObject private var vm: WeatherViewModel
    @EnvironmentObject private var preferences: PreferencesStore

    init(vm: WeatherViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        content
            .navigationTitle(vm.initialCity ?? "Погода")
            .navigationBarTitleDisplayMode(.inline)
            .task { await vm.loadInitial() }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .idle:
            ContentUnavailableView(
                "Выберите город",
                systemImage: "magnifyingglass",
                description: Text("Вернитесь к списку и выберите город.")
            )

        case .loading:
            ProgressView("Загрузка…")
                .controlSize(.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let weather):
            ScrollView {
                VStack(spacing: 20) {
                    CurrentWeatherHeader(
                        city: weather.city,
                        weather: weather.current,
                        temperatureUnit: preferences.preferences.temperatureUnit
                    )
                    MetricsRow(
                        current: weather.current,
                        temperatureUnit: preferences.preferences.temperatureUnit,
                        windUnit: preferences.preferences.windUnit
                    )
                    HourlyForecastStrip(
                        items: weather.hourly,
                        temperatureUnit: preferences.preferences.temperatureUnit
                    )
                    DailyForecastList(
                        items: weather.daily,
                        temperatureUnit: preferences.preferences.temperatureUnit
                    )
                }
                .padding(.vertical)
            }

        case .notFound(let city):
            ContentUnavailableView(
                "Нет данных",
                systemImage: "cloud.slash",
                description: Text("Не удалось найти погоду для «\(city)».")
            )

        case .error(let message):
            ContentUnavailableView(
                "Что-то пошло не так",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }
}
