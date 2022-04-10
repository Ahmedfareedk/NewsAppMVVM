//
//  OnBoardingViewModel.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 09/04/2022.
//

import Foundation

protocol OnBoardingViewModel {
    var statePresenter: StatePresentable? { get set }
    var selectedCategoryIndex: Int? { get set}
    var selectedCountryIndex: Int? { get set}
    var userFavorite: UserFavoriteCategoryAndCountry? { get }
    func getCategories() -> [String]
    func getCountries() -> [String]
    func startHeadlines()
}

class OnBoardingViewModelImplementation: OnBoardingViewModel {
    
    private var categories = NewsCategory.allCases
    private var countries = NewsCountry.allCases
    private(set) var userFavorite: UserFavoriteCategoryAndCountry?
    var statePresenter: StatePresentable?
    var selectedCategoryIndex: Int?
    var selectedCountryIndex: Int?
    
    
    func getCategories() -> [String] {
        categories.map { $0.rawValue.capitalized }
    }
    
    func getCountries() -> [String] {
        countries.map { $0.rawValue }
    }
    
    func startHeadlines() {
        guard let selectedCountryIndex = selectedCountryIndex,
              let selectedCategoryIndex = selectedCategoryIndex else {
                  statePresenter?.render(state: .error(ErrorHandler.selectDropDown))
                  return
              }
        
        let userFavorite = UserFavoriteCategoryAndCountry(countryISO: countries[selectedCountryIndex].isoCode,
                                        category: categories[selectedCategoryIndex].rawValue,
                                        country: countries[selectedCountryIndex].rawValue)
        UserDefaultsManager.saveUserFavorite(userFavorite)
        self.userFavorite = userFavorite
        statePresenter?.render(state: .populated)
    }
}


