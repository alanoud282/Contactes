//
//  ContactDetailView.swift
//  Contactes2
//
//  Created by ساره المرشد on 08/06/2023.
//
import SwiftUI
//import FirebaseFirestore
//import FirebaseDatabase
//import FirebaseStorage
//import ContactsUI

struct ContactDetailView: View {
    let contact: Contact
    @ObservedObject var viewModel: ContactViewModel
    
    var body: some View {
        VStack {
            Text(contact.imageInitials ?? "")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color.gray)
                .clipShape(Circle())
            Text(contact.firstName + " " + contact.lastName)
                .font(.title)
            Text(contact.phoneNumber)
                .font(.headline)
                
//            Button(action: {
//                viewModel.deleteContact(contact)
//            }) {
////                Text("Delete")
////                    .foregroundColor(.red)
//            }
            Spacer()
        }
        .padding()
    }
}
//
//struct ContactDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactDetailView()
//    }
//}
