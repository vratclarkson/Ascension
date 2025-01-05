import SwiftUI

// MountainView: Central visualization of user's progress
struct MountainView: View {
    let summit: Summit
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.blue.opacity(0.3)],
                    startPoint: .bottom,
                    endPoint: .top
                )
                
                // Mountain peaks for each pillar
                HStack(spacing: 0) {
                    ForEach(summit.pillars) { pillar in
                        PillarPeakView(pillar: pillar, totalWidth: geometry.size.width / CGFloat(summit.pillars.count))
                    }
                }
            }
        }
        .aspectRatio(1.5, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// PillarPeakView: Individual mountain peak representing a pillar
struct PillarPeakView: View {
    let pillar: Pillar
    let totalWidth: CGFloat
    
    private var progress: Double {
        pillar.metrics.isEmpty ? 0.0 :
            pillar.metrics.reduce(0.0) { $0 + ($1.currentValue / $1.targetValue) } / Double(pillar.metrics.count)
    }
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let peak = CGPoint(x: totalWidth / 2, y: geometry.size.height * (1 - CGFloat(progress)))
                let leftBase = CGPoint(x: 0, y: geometry.size.height)
                let rightBase = CGPoint(x: totalWidth, y: geometry.size.height)
                
                path.move(to: leftBase)
                path.addLine(to: peak)
                path.addLine(to: rightBase)
                path.closeSubpath()
            }
            .fill(LinearGradient(
                colors: [.blue, .purple],
                startPoint: .bottom,
                endPoint: .top
            ))
            
            // Ascent markers
            VStack(spacing: 10) {
                ForEach(pillar.ascents) { ascent in
                    Circle()
                        .fill(Color.white)
                        .frame(width: 6, height: 6)
                        .offset(y: calculateAscentOffset(ascent, in: geometry))
                }
            }
            
            // Pillar title
            Text(pillar.title)
                .font(.caption)
                .foregroundColor(.white)
                .rotationEffect(.degrees(-45))
                .position(x: totalWidth / 2, y: geometry.size.height - 20)
        }
    }
    
    private func calculateAscentOffset(_ ascent: Ascent, in geometry: GeometryProxy) -> CGFloat {
        // Calculate vertical position based on timeframe and dates
        let totalHeight = geometry.size.height
        let progress = calculateAscentProgress(ascent)
        return totalHeight * CGFloat(1 - progress)
    }
    
    private func calculateAscentProgress(_ ascent: Ascent) -> Double {
        let now = Date()
        guard now >= ascent.startDate && now <= ascent.endDate else {
            return now < ascent.startDate ? 0 : 1
        }
        
        let total = ascent.endDate.timeIntervalSince(ascent.startDate)
        let elapsed = now.timeIntervalSince(ascent.startDate)
        return elapsed / total
    }
}

// Preview provider
struct MountainView_Previews: PreviewProvider {
    static var previews: some View {
        MountainView(summit: Summit(
            title: "Preview Summit",
            description: "Test description",
            image: "",
            pillars: [
                Pillar(title: "Pillar 1", description: "Test", metrics: [], timeline: 5, ascents: []),
                Pillar(title: "Pillar 2", description: "Test", metrics: [], timeline: 5, ascents: [])
            ]
        ))
        .frame(height: 300)
        .padding()
    }
}

// End of file. No additional code.
