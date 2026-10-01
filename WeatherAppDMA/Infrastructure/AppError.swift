import Foundation

enum AppError: LocalizedError, Equatable {
    case emptyQuery
    case cityNotFound(String)
    case resourceNotFound(String)
    case decodingFailed(String)
    case notImplemented
    case unknown

    var errorDescription: String? {
        switch self {
        case .emptyQuery:
            return "Введите название города."
        case .cityNotFound(let city):
            return "Нет данных о погоде для «\(city)»."
        case .resourceNotFound(let name):
            return "Ресурс «\(name)» отсутствует в бандле приложения."
        case .decodingFailed(let details):
            return "Не удалось декодировать данные о погоде: \(details)"
        case .notImplemented:
            return "Этот источник данных ещё не реализован."
        case .unknown:
            return "Что-то пошло не так."
        }
    }
}
