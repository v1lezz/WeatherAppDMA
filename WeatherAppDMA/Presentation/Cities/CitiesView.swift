import SwiftUI

struct CitiesView: View {
    @StateObject private var vm: CitiesViewModel
    private let makeWeatherView: (String) -> WeatherView

    init(vm: CitiesViewModel, makeWeatherView: @escaping (String) -> WeatherView) {
        _vm = StateObject(wrappedValue: vm)
        self.makeWeatherView = makeWeatherView
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Города")
                .searchable(
                    text: $vm.query,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Поиск города"
                )
                .task { await vm.load() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .loading:
            ProgressView("Загрузка…")
                .controlSize(.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded:
            let cities = vm.filteredCities
            if cities.isEmpty {
                ContentUnavailableView(
                    "Ничего не найдено",
                    systemImage: "magnifyingglass",
                    description: Text("Попробуйте изменить запрос.")
                )
            } else {
                List(cities) { city in
                    NavigationLink {
                        makeWeatherView(city.name)
                    } label: {
                        CityRow(city: city)
                    }
                }
                .listStyle(.plain)
            }

        case .error(let message):
            ContentUnavailableView(
                "Не удалось загрузить города",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }
}

private struct CityRow: View {
    let city: CitySummary

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: city.condition.sfSymbol)
                .symbolRenderingMode(.multicolor)
                .font(.title2)
                .frame(width: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(city.name)
                    .font(.headline)
                Text(city.condition.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(Int(city.currentTemperatureC.rounded()))°")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
