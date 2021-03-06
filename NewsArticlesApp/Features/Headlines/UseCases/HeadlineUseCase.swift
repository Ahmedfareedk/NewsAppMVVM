//
//  HeadlineUseCase.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 09/04/2022.
//

import Foundation

typealias ArticleResult = Result<ArticleResponse, Error>
typealias ArticleBlock = (ArticleResult) -> Void

protocol HeadLinesDataProviderUseCase {
    func loadData(requestParameters: HeadlineArticleParameters, completion: ArticleBlock?)
}

class HeadLinesDataProvider: HeadLinesDataProviderUseCase {
    
    var apiHandler: ApiHandlerProtocol
    
    init(apiHandler: ApiHandlerProtocol = ApiHandler.shared) {
        self.apiHandler = apiHandler
    }
    
    func loadData(requestParameters: HeadlineArticleParameters, completion: ArticleBlock?) {
        let request = HeadlinesNetworking.fetchArticles(requestParameters)
        apiHandler.fetchData(request: request, mappingClass: ArticleResponse.self) {[weak self] response in
            guard let self = self else { return }
            self.handleResponse(result: response, completion: completion)
        }
    }
    
    private func handleResponse(result: ArticleResult, completion: ArticleBlock?) {
        switch result {
        case .success(let value):
            completion?(.success(value))
        case .failure(let error):
            debugPrint(error.localizedDescription)
            completion?(.failure(error))
        }
    }
}
