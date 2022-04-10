//
//  HeadlinesViewController.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 10/04/2022.
//

import UIKit

class HeadlinesViewController: UIViewController {
    @IBOutlet weak var headLinesSearchBar: CustomSearchBar!
    
    @IBOutlet weak var headLinesIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headLinesTableView: UITableView!
    
    private var viewModel: HeadLinesViewModel
    private var footerActivityIndicator: UIActivityIndicatorView?
    

    init(viewModel: HeadLinesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkLastCacheDate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopTimer()
        dismissKeyBoard()
    }
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.statePresenter = self
        viewModel.fetchArticles(isRefresh: false)
        setupView()
    }
}

fileprivate extension HeadlinesViewController {
    
    func setupView() {
        setupNewsTableView()
        setupSearchBar()
        handleTapOnView()
    
    }
    
    func setupNewsTableView() {
        headLinesTableView.delegate = self
        headLinesTableView.dataSource = self
        headLinesTableView.registerCellNib(cellClass: HeadlineTableViewCell.self)
        headLinesTableView.keyboardDismissMode = .onDrag
    }
    
    func reloadData() {
        removeIndicators()
        headLinesTableView.isHidden = false
        headLinesTableView.reloadData()
    }
    
    func removeIndicators() {
        headLinesTableView.removeActivityIndicatorFromFooter(footerActivityIndicator)
        dismissLoading()
    }
    
    func setupSearchBar() {
        headLinesSearchBar.textDidChange = {[weak self] text in
            guard let self = self else { return}
            self.viewModel.searchForArticle(by: text)
        }
    }
    
    func showLoading() {
        headLinesTableView.isUserInteractionEnabled = false
        headLinesIndicator.startAnimating()
    }
    
    func dismissLoading() {
        headLinesTableView.isUserInteractionEnabled = true
        headLinesIndicator.stopAnimating()
    }
    
    func scrollToTop() {
        removeIndicators()
        headLinesTableView.reloadData()
        if viewModel.getArticlesCount() != 0 {
            headLinesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func handleTapOnView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
    
}

extension HeadlinesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getArticlesCount() - 1 {
            viewModel.loadMoreArticles()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailsViewModel = DetailsViewModel(article: viewModel.getArticle(at: indexPath.row))
//        let detailsViewController = DetailsViewController(viewModel: detailsViewModel)
//        push(viewController: detailsViewController)
    }
}

extension HeadlinesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getArticlesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as HeadlineTableViewCell
        let article = viewModel.getArticle(at: indexPath.row)
        cell.configureCell(imageURL: article.urlToImage, title: article.title)
        return cell
    }
}

extension HeadlinesViewController: StatePresentable {
    func render(state: State) {
        switch state {
        case .loading:
            showLoading()
        case .loadingMore:
            footerActivityIndicator = headLinesTableView.showActivityIndicatorInFooter()
        case .error(let error):
            reloadData()
            show(error: error)
        case .empty:
            setEmptyView()
        case .populated:
            headLinesTableView.restore()
            reloadData()
        case .refresh:
            scrollToTop()
        }
    }
    
    func setEmptyView() {
        headLinesTableView.setEmptyView(title: "No result found")
    }
    
    

}
