//
//  DetailsViewController.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 10/04/2022.
//

import UIKit
import SafariServices

class DetailsViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var atricleAuthorLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    

    private var viewModel: DetailsViewModelProtocol
    
    init(viewModel: DetailsViewModelProtocol) {
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
    
    @IBAction private func backAction(_ sender: UIButton) {
        pop()
    }
    
    @IBAction private func openArticleAction(_ sender: UIButton) {
        viewModel.openArticleInSafari()
    }
}

fileprivate extension DetailsViewController {
    func setupView() {
        detailImageView.layer.cornerRadius = 10
        updateUI()
    }
    
    func updateUI() {
        let article = viewModel.article
        atricleAuthorLabel.text = article.author ?? "-"
        sourceLabel.text = article.source?.name ?? "-"
        descriptionLabel.text = article.articleDescription ?? "-"
        if let imageURL = article.urlToImage {
            detailImageView.setImageWith(url: imageURL)
        }
    }
    
    func openSafariView() {
        guard let url = viewModel.articleURL else { return }
        let safari = SFSafariViewController(url: url)
        present(safari, animated: true)
    }
}

extension DetailsViewController: StatePresentable {
    func render(state: State) {
        switch state {
        case .error(let error):
            show(error: error)
        case .populated:
            openSafariView()
        default:
            break
        }
    }
}
