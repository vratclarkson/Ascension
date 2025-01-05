import SwiftUI

struct DailyCheckInView: View {
    let summit: Summit
    @State private var selectedDate = Date()
    @State private var showingJournal = false
    @State private var journalEntry = ""
    
    var body: some View {
        List {
            Section {
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
            
            Section(header: Text("Daily Progress")) {
                ForEach(summit.pillars) { pillar in
                    PillarCheckInCard(pillar: pillar, date: selectedDate)
                }
            }
            
            Section {
                Button(action: { showingJournal = true }) {
                    Label("Add Journal Entry", systemImage: "square.and.pencil")
                }
            }
        }
        .navigationTitle("Daily Check-in")
        .sheet(isPresented: $showingJournal) {
            NavigationView {
                Form {
                    TextEditor(text: $journalEntry)
                        .frame(height: 200)
                }
                .navigationTitle("Journal Entry")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingJournal = false
                    },
                    trailing: Button("Save") {
                        // Save journal entry
                        showingJournal = false
                    }
                )
            }
        }
    }
}

struct PillarCheckInCard: View {
    let pillar: Pillar
    let date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(pillar.title)
                .font(.headline)
            
            ForEach(pillar.metrics) { metric in
                MetricUpdateRow(metric: metric)
            }
            
            if let todaysBasecamp = findTodaysBasecamp() {
                Toggle(isOn: .constant(todaysBasecamp.isCompleted)) {
                    Text(todaysBasecamp.title)
                        .foregroundColor(todaysBasecamp.isCompleted ? .green : .primary)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func findTodaysBasecamp() -> Basecamp? {
        // Find basecamp for the current date
        pillar.ascents
            .flatMap { $0.basecamps }
            .first { Calendar.current.isDate($0.dueDate, inSameDayAs: date) }
    }
}

struct MetricUpdateRow: View {
    let metric: Metric
    @State private var currentValue: Double
    
    init(metric: Metric) {
        self.metric = metric
        _currentValue = State(initialValue: metric.currentValue)
    }
    
    var body: some View {
        HStack {
            Text(metric.name)
            Spacer()
            TextField("Value", value: $currentValue, format: .number)
                .textFieldStyle(.roundedBorder)
                .frame(width: 100)
            Text(metric.unit)
        }
    }
}

// End of file. No additional code.
