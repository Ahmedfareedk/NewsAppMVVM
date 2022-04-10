//
//  OnboardingViewController.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 09/04/2022.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var countryDropDown: CustomDropDown!
    
    @IBOutlet weak var categoryDropDown: CustomDropDown!
    
    
    private var viewModel: OnBoardingViewModel
    
    
    init(viewModel: OnBoardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.statePresenter = self
        setupView()
    }
    
  
    @IBAction private func startAction(_ sender: UIButton) {
        print("Hey")
        viewModel.startHeadlines()
    }
}

fileprivate extension OnboardingViewController {
    func setupView(){
        implementCountriesDropDown()
        implementCategoriesDropDown()
    }
    
    func implementCountriesDropDown() {
        countryDropDown.dropMenuItems = viewModel.getCountries()
        countryDropDown.didSelectItem = {[weak self] index in
            guard let self = self else { return }
            self.viewModel.selectedCountryIndex  = index
        }
    }
    
    func implementCategoriesDropDown() {
        categoryDropDown.dropMenuItems = viewModel.getCategories()
        categoryDropDown.didSelectItem = {[weak self] index in
            guard let self = self else { return }
            self.viewModel.selectedCategoryIndex  = index
        }
    }
    
    func navigateToHome() {
        guard let userFavorite = viewModel.userFavorite else { return }
        let headLinesViewModel = HeadLinesViewModelImplementation(userFavorite: userFavorite, dataSource: HeadLinesDataProvider())
        let headLineViewController = HeadlinesViewController(viewModel: headLinesViewModel)
        setRootViewController(to: headLineViewController)}
}

extension OnboardingViewController: StatePresentable {
    
    func render(state: State) {
        switch state {
        case .error(let message):
            show(error: message)
        case .populated:
            navigateToHome()
        default:
            break
        }
    }
}
