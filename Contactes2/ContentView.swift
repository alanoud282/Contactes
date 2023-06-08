//
//  ContentView.swift
//  Contactes2
//
//  Created by ساره المرشد on 08/06/2023.
//

import SwiftUI

import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage
import ContactsUI

struct Contact: Identifiable, Codable {
    let id: String?
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let imageInitials: String?
    
    init(id: String,firstName: String, lastName: String, phoneNumber: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.imageInitials = String(firstName.prefix(1) + lastName.suffix(1)).uppercased()
    }
}

//struct SearchBar: UIViewRepresentable {
//    @Binding var text: String
//
//    class Coordinator: NSObject, UISearchBarDelegate {
//        @Binding var text: String
//
//        init(text: Binding<String>) {
//            _text = text
//        }
//
//        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//            text = searchText
//        }
//    }
//    
//    func makeUIView(context: Context) -> UISearchBar {
//        let searchBar = UISearchBar(frame: .zero)
//        searchBar.delegate = context.coordinator
//        searchBar.searchBarStyle = .minimal
//        searchBar.autocapitalizationType = .none
//        searchBar.placeholder = "Search"
//        return searchBar
//    }
//    
//    func updateUIView(_ uiView: UISearchBar, context: Context) {
//        uiView.text = text
//    }
//    
//    func makeCoordinator() -> SearchBar.Coordinator {
//        return Coordinator(text: $text)
//    }
//}


class ContactViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
    private var databaseRef = Database.database().reference().child("contacts")
    private var handle: DatabaseHandle?
    
    init() {
        fetchContacts()
    }
    
    func fetchContacts() {
        handle = databaseRef.observe(.value, with: { snapshot in
            var contacts: [Contact] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let data = snapshot.value as? [String: Any],
                   let firstName = data["firstName"] as? String,
                   let lastName = data["lastName"] as? String,
                   let phoneNumber = data["phoneNumber"] as? String {
                    let id = snapshot.key
                    let contact = Contact(id: id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
                    contacts.append(contact)
                }
            }
            self.contacts = contacts
        })
    }
    
    func addContact(_ contact: Contact) {
        let contactData = ["firstName": contact.firstName,
                           "lastName": contact.lastName,
                           "phoneNumber": contact.phoneNumber,
                           "imageInitials": contact.imageInitials]
        let contactRef = databaseRef.childByAutoId()
        contactRef.setValue(contactData)
    }
//
//    func deleteContact(_ contact: Contact) {
//        if let id = contact.id {
//            databaseRef.child(id).removeValue()
//        }
//    }
//
    deinit {
        if let handle = handle {
            databaseRef.removeObserver(withHandle: handle)
        }
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.placeholder = "Search"
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }
}



struct ContactView: View {
    @StateObject var viewModel = ContactViewModel()
    @State private var searchText = ""
    @State private var showAddContactView = false
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return viewModel.contacts
        } else {
            return viewModel.contacts.filter { contact in
                contact.firstName.localizedCaseInsensitiveContains(searchText) ||
                    contact.lastName.localizedCaseInsensitiveContains(searchText) ||
                    contact.phoneNumber.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.top, 10)
                List(filteredContacts) { contact in
                    NavigationLink(destination: ContactDetailView(contact: contact, viewModel: viewModel)) {
                        ContactRow(contact: contact)
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            .navigationBarItems(
                trailing: Button(action: {
                    self.showAddContactView.toggle()
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showAddContactView) {
                AddContactView(viewModel: AddContactViewModel(contactViewModel: viewModel))
            }
        }.navigationBarTitle("iphone")
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContactRow: View {
    let contact: Contact
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(contact.firstName + " " + contact.lastName)
                    .font(.headline)
                Text(contact.phoneNumber)
                    .font(.subheadline)
            }
        }
    }
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
