//
//  AddContactView.swift
//  Contactes2
//
//  Created by ساره المرشد on 08/06/2023.
//

import SwiftUI

//import FirebaseFirestore
import FirebaseDatabase
//import FirebaseStorage
//import ContactsUI


struct AddContactView: View {
    @ObservedObject var viewModel: AddContactViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("First Name", text: $viewModel.firstName)
                    TextField("Last Name", text: $viewModel.lastName)
                }
                
                Section {
                    TextField("Phone Number", text: $viewModel.phoneNumber)
                        .keyboardType(.phonePad)
//                    TextField("Email", text: $viewModel.email)
//                        .keyboardType(.emailAddress)
                }
                
//                Section {
//                    TextField("Address", text: $viewModel.address)
//                    TextField("Company", text: $viewModel.company)
//                }
//
                Section {
                    Button(action: addContact) {
                        Text("Add Contact")
                    }
                }
            }
            .navigationBarTitle("Add Contact")
        }
    }
    
    func addContact() {
        let contact = Contact(id: viewModel.id, firstName: viewModel.firstName, lastName: viewModel.lastName, phoneNumber: viewModel.phoneNumber)
        viewModel.addContact(contact)
        presentationMode.wrappedValue.dismiss()
    }
}

class AddContactViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
  //  @Published var email = ""
   // @Published var address = ""
//    @Published var company = ""
    @Published var id = ""
    private let databaseRef = Database.database().reference().child("contacts")
    private let contactViewModel: ContactViewModel
    
    init(contactViewModel: ContactViewModel) {
        self.contactViewModel = contactViewModel
    }
    
    func addContact(_ contact: Contact) {
        contactViewModel.addContact(contact)
    }
}

    
//struct AddContactView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddContactView()
//    }
//}
