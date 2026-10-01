import Foundation

enum UnitFormatter {
    static func temperature(celsius: Double, unit: TemperatureUnit) -> String {
        let value = unit.convert(fromCelsius: celsius)
        return "\(Int(value.rounded()))°"
    }

    static func temperatureWithUnit(celsius: Double, unit: TemperatureUnit) -> String {
        let value = unit.convert(fromCelsius: celsius)
        return "\(Int(value.rounded()))\(unit.displayName)"
    }

    static func wind(ms: Double, unit: WindUnit) -> String {
        let value = unit.convert(fromMetersPerSecond: ms)
        return String(format: "%.1f %@", value, unit.displayName)
    }
}
