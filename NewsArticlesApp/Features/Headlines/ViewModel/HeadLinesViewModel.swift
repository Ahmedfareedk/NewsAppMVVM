//
//  HeadLinesViewModel.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 10/04/2022.
//

import Foundation

enum HomeState: Equatable {
    case searching(text: String)
    case notSearching
}

protocol HeadLinesViewModel {
    var statePresenter: StatePresentable? { get set }
    func fetchArticles(isRefresh: Bool)
    func getArticlesCount() -> Int
    func getArticle(at index: Int) -> Article
    func loadMoreArticles()
    func searchForArticle(by text: String)
    func checkLastCacheDate()
    func stopTimer()
}

class HeadLinesViewModelImplementation: HeadLinesViewModel {
    
    private let userFavorite: UserFavoriteCategoryAndCountry
    private let dataSource: HeadLinesDataProviderUseCase
    private var articles = [Article]()
    private var searchedArticles = [Article]()
    private var pageNumber: Int = 1
    private var hasMoreItems: Bool = true
    private var pendingRequestWorkItem: DispatchWorkItem?
    private(set) var currentState: HomeState = .notSearching
    private weak var timer: Timer?
    
    var statePresenter: StatePresentable?
    
    init(userFavorite: UserFavoriteCategoryAndCountry, dataSource: HeadLinesDataProviderUseCase) {
        self.userFavorite = userFavorite
        self.dataSource = dataSource
    }
    
    deinit {
        stopTimer()
    }
    
    func fetchArticles(isRefresh: Bool) {
        pageNumber = 1
        hasMoreItems = true
        if isRefresh {
            loadData(isLoadMore: false, isRefresh: true)
        } else if !loadDataFromCaching() {
            loadData(isLoadMore: false)
        }
    }
    
    func loadMoreArticles() {
        switch currentState {
        case .searching(text: let text):
            loadData(searchText: text, isLoadMore: true)
        case .notSearching:
            loadData(isLoadMore: true)
        }
    }
    
    func getArticlesCount() -> Int {
        let count = currentState == .notSearching ? articles.count : searchedArticles.count
        if count == 0 {
            statePresenter?.render(state: .empty)
        }
        return count
    }
    
    func getArticle(at index: Int) -> Article {
        currentState == .notSearching ? articles[index] : searchedArticles[index]
    }
    
    func searchForArticle(by text: String) {
        hasMoreItems = true
        searchedArticles.removeAll()
        pendingRequestWorkItem?.cancel()
        if text.isEmpty {
            currentState = .notSearching
            loadDataFromCaching()
        } else {
            pageNumber = 1
            let requestWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.currentState = .searching(text: text)
                self.loadData(searchText: text, isLoadMore: false)
            }
            pendingRequestWorkItem = requestWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                          execute: requestWorkItem)
        }
    }
}

fileprivate extension HeadLinesViewModelImplementation {
    
    @discardableResult
    func loadDataFromCaching(state: State = .populated) -> Bool {
        articles = CachingManager.shared.loadArticles()
        pageNumber = articles.count / 20 + 1
        statePresenter?.render(state: state)
        return !articles.isEmpty
    }
    
    func loadData(searchText: String? = nil, isLoadMore: Bool, isRefresh: Bool = false) {
        guard hasMoreItems else { return }
        if isLoadMore {
            statePresenter?.render(state: .loadingMore)
        } else {
            statePresenter?.render(state: .loading)
        }
        let requestParameters = HeadlineArticleParameters(country: userFavorite.countryISO, category: userFavorite.category, page: pageNumber, query: searchText)
        
        dataSource.loadData(requestParameters: requestParameters) {[weak self] result in
            guard let self = self else { return }
            self.handleDataLoading(result: result, isRefresh: isRefresh)
        }
    }
    
    func handleDataLoading(result: ArticleResult, isRefresh: Bool) {
        switch result {
        case .success(let value):
            setData(items: value.articles ?? [], isRefresh: isRefresh)
            checkHasMoreItems(totalResultCount: value.totalResults ?? 0,
                              isNewArrayNotEmpty: !(value.articles?.isEmpty ?? false))
        case .failure(let error):
            statePresenter?.render(state: .error(error))
        }
    }
    
    func setData(items: [Article], isRefresh: Bool) {
        if isRefresh {
            handleRefreshArticles(items: items)
            return
        } else {
            setArticles(items)
        }
    }
    
    func setArticles(_ items: [Article]) {
        switch currentState {
        case .searching:
            self.searchedArticles.append(contentsOf: items)
            statePresenter?.render(state: .populated)
        case .notSearching:
            guard !items.isEmpty else {
                statePresenter?.render(state: .populated)
                return
            }
            var newArticles = self.articles
            newArticles.append(contentsOf: items)
            CachingManager.shared.saveArticles(newArticles)
            startTimer()
            loadDataFromCaching()
        }
    }
    
    func handleRefreshArticles(items: [Article]) {
        CachingManager.shared.saveArticles(items)
        startTimer()
        loadDataFromCaching(state: .refresh)
    }
    
    func checkHasMoreItems(totalResultCount: Int, isNewArrayNotEmpty: Bool) {
        if articles.count < totalResultCount && isNewArrayNotEmpty {
            pageNumber += 1
        } else {
            hasMoreItems = false
        }
    }
}

extension HeadLinesViewModelImplementation {
    
   private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 60 * 15, repeats: true, block: {[weak self] _ in
            guard let self = self else { return }
            self.fetchArticles(isRefresh: true)
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func checkLastCacheDate() {
        guard let lastCache = UserDefaultsManager.getLastCacheDate() else { return }
        let difference = lastCache.calculateDifferenceInMinutes()
        if difference > 15 {
            self.fetchArticles(isRefresh: true)
        }
    }
}

