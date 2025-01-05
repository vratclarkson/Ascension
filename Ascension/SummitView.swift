import SwiftUI

struct SummitView: View {
    @State private var summit: Summit? = nil
    @State private var showingAddSummit = false
    
    var body: some View {
        VStack {
            if let summit = summit {
                // Display existing summit
                VStack(alignment: .leading, spacing: 16) {
                    Text(summit.title)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(summit.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    // We'll add pillar list here later
                    Text("Pillars: \(summit.pillars.count)")
                        .font(.headline)
                }
                .padding()
            } else {
                // Show add summit button
                Button(action: { showingAddSummit = true }) {
                    VStack(spacing: 12) {
                        Image(systemName: "mountain.2.fill")
                            .font(.system(size: 60))
                        
                        Text("Set Your Summit")
                            .font(.title2)
                        
                        Text("Define your ultimate goal")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingAddSummit) {
            AddSummitView { newSummit in
                self.summit = newSummit
            }
        }
    }
}

struct SummitView_Previews: PreviewProvider {
    static var previews: some View {
        SummitView()
    }
}

// End of file. No additional code.
