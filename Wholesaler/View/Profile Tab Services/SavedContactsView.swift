import SwiftUI

struct SavedContact: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    var name: String
    var value: String
}

struct SavedContactsView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss

    @State private var contacts: [SavedContact] = []
    @State private var nameInput = ""
    @State private var valueInput = ""
    @State private var isSaving = false

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Add Contact")) {
                        TextField("Name", text: $nameInput)
                        TextField("Email or Phone", text: $valueInput)
                        Button("Save") {
                            saveContact()
                        }
                        .disabled(nameInput.isEmpty || valueInput.isEmpty)
                    }

                    Section(header: Text("Saved Contacts")) {
                        if contacts.isEmpty {
                            Text("No saved contacts")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(contacts) { contact in
                                VStack(alignment: .leading) {
                                    Text(contact.name)
                                        .fontWeight(.semibold)
                                    Text(contact.value)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .onDelete(perform: deleteContact)
                        }
                    }
                }
            }
            .navigationTitle("Saved Contacts")
      
            .onAppear {
                loadContacts()
            }
        }
    }

    private func saveContact() {
        let newContact = SavedContact(name: nameInput, value: valueInput)
        contacts.append(newContact)
        nameInput = ""
        valueInput = ""
        storeContacts()
    }

    private func deleteContact(at offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
        storeContacts()
    }

    private func storeContacts() {
        guard let uid = authVM.currentUser?.uid else { return }
        let data = try? JSONEncoder().encode(contacts)
        if let data = data {
            authVM.firestore.collection("users").document(uid).setData([
                "contacts": data
            ], merge: true)
        }
    }

    private func loadContacts() {
        guard let uid = authVM.currentUser?.uid else { return }
        authVM.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let data = snapshot?.data(),
               let rawData = data["contacts"] as? Data,
               let decoded = try? JSONDecoder().decode([SavedContact].self, from: rawData) {
                self.contacts = decoded
            }
        }
    }
}
