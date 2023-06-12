//
//  googleMap_studyApp.swift
//  googleMap_study
//
//  Created by Heeoh Son on 2023/05/24.
//

import SwiftUI
import GoogleMaps
import UIKit

let googleApiKey = "AIzaSyBDX07bNscs4Y-qT1KjJN_q3ugd1u7lDMA"

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Did finish launching")
        
        GMSServices.provideAPIKey(googleApiKey)
        return true
    }
}

@main
struct googleMap_studyApp: App {
    
//    @StateObject var viewRouter = ViewRouter()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

