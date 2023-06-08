//
//  Contactes2App.swift
//  Contactes2
//
//  Created by ساره المرشد on 08/06/2023.
//


import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage
//import ContactsUI
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Contactes2App: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      NavigationView {
          ContactView()
      }
    }
  }
}
