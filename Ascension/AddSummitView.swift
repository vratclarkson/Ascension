import SwiftUI

struct AddSummitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""
    
    var onAdd: (Summit) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Summit Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Set Your Summit")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Add") {
                    let newSummit = Summit(
                        title: title,
                        description: description,
                        image: "", // We'll add image support later
                        pillars: []
                    )
                    onAdd(newSummit)
                    dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
}

struct AddSummitView_Previews: PreviewProvider {
    static var previews: some View {
        AddSummitView { _ in }
    }
}

// End of file. No additional code.
