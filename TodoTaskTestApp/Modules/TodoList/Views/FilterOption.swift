import Foundation

enum FilterOption: String {
    case all = "All"
    case open = "Open"
    case closed = "Closed"
    
    var tag: Int {
        return switch self {
        case .all: 0
        case .open: 1
        case .closed: 2
        }
    }
    
    init?(tag: Int) {
        switch tag {
        case 0: self = .all
        case 1: self = .open
        case 2: self = .closed
        default: return nil
        }
    }
}
