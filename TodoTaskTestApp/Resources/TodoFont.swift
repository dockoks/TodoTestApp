import UIKit

struct TodoFont {
    static let shared = TodoFont()
    
    // MARK: - Styles
    enum Styles {
        static let header = TodoFont.shared.font(size: 24, weight: .bold)
        static let subtitle = TodoFont.shared.font(size: 16, weight: .medium)
        static let body = TodoFont.shared.font(size: 16, weight: .semibold)
        static let footnote = TodoFont.shared.font(size: 14, weight: .medium)
        static let caption = TodoFont.shared.font(size: 14, weight: .regular)
        static let caption2 = TodoFont.shared.font(size: 12, weight: .black)
    }
    
    // MARK: - Font Names
    private let boldTodoFontName = "Manrope-Bold"
    private let extraBoldTodoFontName = "Manrope-ExtraBold"
    private let extraLightTodoFontName = "Manrope-ExtraLight"
    private let lightTodoFontName = "Manrope-Light"
    private let mediumTodoFontName = "Manrope-Medium"
    private let regularTodoFontName = "Manrope-Regular"
    private let semiboldTodoFontName = "Manrope-Semibold"

    // MARK: - Public Methods
    func font(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        let fontName = self.fontName(weight: weight)
        guard let customFont = UIFont(name: fontName, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
        return customFont
    }

    // MARK: - Private Helper Methods
    private func fontName(weight: UIFont.Weight) -> String {
        return switch weight {
        case .black: extraBoldTodoFontName
        case .bold: boldTodoFontName
        case .semibold: semiboldTodoFontName
        case .medium: mediumTodoFontName
        case .regular: regularTodoFontName
        case .light: lightTodoFontName
        case .ultraLight: extraLightTodoFontName
        default: regularTodoFontName
        }
    }
}
