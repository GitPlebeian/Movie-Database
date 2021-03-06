//
//  AppDelegate.swift
//  Movie Database
//
//  Created by Jackson Tubbs on 11/4/20.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        MovieController.shared.loadFilms()
        MovieController.shared.loadLastSelectedFilm()
        return true
    }
}

