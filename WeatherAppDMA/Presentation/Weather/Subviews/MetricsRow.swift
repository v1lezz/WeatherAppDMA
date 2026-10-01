import SwiftUI

struct MetricsRow: View {
    let current: CurrentWeather

    var body: some View {
        HStack(spacing: 12) {
            metric(icon: "thermometer.medium", title: "Ощущается", value: "\(Int(current.feelsLikeC.rounded()))°")
            metric(icon: "humidity.fill",      title: "Влажность", value: "\(current.humidityPercent)%")
            metric(icon: "wind",               title: "Ветер",     value: String(format: "%.1f м/с", current.windMS))
        }
        .padding(.horizontal)
    }

    private func metric(icon: String, title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.tint)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}
