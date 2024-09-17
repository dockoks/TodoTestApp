import UIKit

struct ColorPalette {
    
    enum Background {
        static let layerOne = UIColor(lightHex: 0xF5F5F5, darkHex: 0x121212)
        static let layerTwo = UIColor(lightHex: 0xFFFFFF, darkHex: 0x212121)
    }
    
    enum Text {
        static let primary = UIColor(lightHex: 0x000000, darkHex: 0xFFFFFF, alpha: 1)
        static let secondary = UIColor(lightHex: 0x000000, darkHex: 0xFFFFFF, alpha: 0.5)
        static let tertiary = UIColor(lightHex: 0x000000, darkHex: 0xFFFFFF, alpha: 0.25)
    }
    
    enum Outline {
        static let light = UIColor(lightHex: 0x000000, darkHex: 0xFFFFFF, alpha: 0.08)
    }
    
    enum Main {
        static let primaryBlue = UIColor(lightHex: 0x0B5AFE, darkHex: 0x0B5AFE, alpha: 1)
        static let secondaryBlue = UIColor(lightHex: 0x0B5AFE, darkHex: 0x0B5AFE, alpha: 0.1)
        static let primaryRed = UIColor(lightHex: 0xFF3B30,darkHex: 0xFF453A,alpha: 1.0)
        static let secondaryRed = UIColor(lightHex: 0xFF5E57,darkHex: 0xFF6B64,alpha: 0.1)
        static let primaryGreen = UIColor(lightHex: 0x34C759,darkHex: 0x30D158,alpha: 1.0)
        static let secondaryGreen = UIColor(lightHex: 0x66D4A8,darkHex: 0x70E0A5,alpha: 0.1)
    }
}

