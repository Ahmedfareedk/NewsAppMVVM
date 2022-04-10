//
//  SceneDelegate.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 09/04/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene as! UIWindowScene)
        checkIfHasFavorites()
    }
}

fileprivate extension SceneDelegate {
    
    func checkIfHasFavorites() {
        if let userFavorite = UserDefaultsManager.getUserFavorite() {
            let headlinesViewModel = HeadLinesViewModelImplementation(userFavorite: userFavorite, dataSource: HeadLinesDataProvider())
            let headlinesViewController = HeadlinesViewController(viewModel: headlinesViewModel)
            setRootViewController(to: headlinesViewController)
        } else {
            let onboardingViewModel = OnBoardingViewModelImplementation()
            let onboardingViewController = OnboardingViewController(viewModel: onboardingViewModel)
            setRootViewController(to: onboardingViewController)
        }
    }
    
    func setRootViewController(to viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}



