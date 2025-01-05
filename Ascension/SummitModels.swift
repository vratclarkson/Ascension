import Foundation

struct Summit: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var image: String // Name of image asset
    var pillars: [Pillar]
}

struct Pillar: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var metrics: [Metric]
    var timeline: Int // Number of years
    var ascents: [Ascent]
}

struct Metric: Identifiable {
    let id = UUID()
    var name: String
    var targetValue: Double
    var currentValue: Double
    var unit: String
}

struct Ascent: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var timeframe: TimeFrame
    var startDate: Date
    var endDate: Date
    var basecamps: [Basecamp]
}

struct Basecamp: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    var dueDate: Date
}

enum TimeFrame {
    case yearly
    case quarterly
    case monthly
    case weekly
    case daily
}

// End of file. No additional code.
