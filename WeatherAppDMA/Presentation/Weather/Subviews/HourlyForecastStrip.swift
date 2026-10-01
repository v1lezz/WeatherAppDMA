import SwiftUI

struct HourlyForecastStrip: View {
    let items: [HourlyForecast]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Почасовой прогноз")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(items) { item in
                        VStack(spacing: 6) {
                            Text(Self.hourFormatter.string(from: item.date))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Image(systemName: item.condition.sfSymbol)
                                .symbolRenderingMode(.multicolor)
                                .font(.title3)
                            Text("\(Int(item.temperatureC.rounded()))°")
                                .font(.callout)
                                .fontWeight(.medium)
                        }
                        .frame(width: 56)
                        .padding(.vertical, 10)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private static let hourFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "HH"
        return f
    }()
}
