import SwiftUI

struct AddPillarView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var timeline = 5 // Default 5 years
    @State private var metrics: [Metric] = []
    @State private var showingAddMetric = false
    
    var onAdd: (Pillar) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pillar Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    
                    Stepper("Timeline: \(timeline) years", value: $timeline, in: 1...40)
                }
                
                Section(
                    header: HStack {
                        Text("Metrics")
                        Spacer()
                        Button(action: { showingAddMetric = true }) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                ) {
                    if metrics.isEmpty {
                        Text("No metrics added")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(metrics) { metric in
                            VStack(alignment: .leading) {
                                Text(metric.name)
                                    .font(.headline)
                                Text("Target: \(metric.targetValue, specifier: "%.1f") \(metric.unit)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onDelete(perform: deleteMetric)
                    }
                }
            }
            .navigationTitle("Add Pillar")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Add") {
                    let newPillar = Pillar(
                        title: title,
                        description: description,
                        metrics: metrics,
                        timeline: timeline,
                        ascents: []
                    )
                    onAdd(newPillar)
                    dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
        .sheet(isPresented: $showingAddMetric) {
            AddMetricView { metric in
                metrics.append(metric)
            }
        }
    }
    
    private func deleteMetric(at offsets: IndexSet) {
        metrics.remove(atOffsets: offsets)
    }
}

struct AddMetricView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var targetValue = 0.0
    @State private var unit = ""
    
    var onAdd: (Metric) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Target Value", value: $targetValue, format: .number)
                    .keyboardType(.decimalPad)
                TextField("Unit", text: $unit)
            }
            .navigationTitle("Add Metric")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Add") {
                    let metric = Metric(
                        name: name,
                        targetValue: targetValue,
                        currentValue: 0,
                        unit: unit
                    )
                    onAdd(metric)
                    dismiss()
                }
                .disabled(name.isEmpty || unit.isEmpty)
            )
        }
    }
}

struct AddPillarView_Previews: PreviewProvider {
    static var previews: some View {
        AddPillarView { _ in }
    }
}

// End of file. No additional code.
