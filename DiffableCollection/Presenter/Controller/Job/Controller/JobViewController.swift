//
//  JobViewController.swift
//  DiffableCollection
//
//  Created by Fabrício Masiero on 30/04/20.
//  Copyright © 2020 Fabrício Masiero. All rights reserved.
//

import UIKit
import WebKit

class JobViewController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var buttonApply: UIButton!
    
    private let viewModel: JobViewModel
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: JobViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
//        title = "Jobs"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func configureView() {
        webView.navigationDelegate = self
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-150.0)
        view.addSubview(webView)
        
        webView.loadHTMLString(viewModel.job.description, baseURL: nil)
        labelTitle.text = viewModel.job.title
        labelLocation.text = viewModel.job.location
        labelType.text = viewModel.job.type
        labelDate.text = viewModel.job.createdDate
        navigationBarView()
    }
    
    private func navigationBarView() {
        guard let imageUrl = viewModel.job.imageUrl, let url = URL(string: imageUrl) else {
            title = viewModel.job.company ?? viewModel.job.title
            return
        }
        let viewNavigation = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        viewNavigation.backgroundColor = .clear
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 40, height: 40))
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.setImage(url: url) { image in
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
        let labelCompany = UILabel(frame: CGRect(x: imageView.frame.size.width + imageView.frame.origin.x + 6, y: 0, width: viewNavigation.frame.size.width - imageView.frame.size.width - 4, height: 40))
        
        labelCompany.text = viewModel.job.company ?? viewModel.job.title
        
        viewNavigation.addSubview(imageView)
        viewNavigation.addSubview(labelCompany)
        navigationItem.titleView = viewNavigation
    }
    
    @IBAction func apply(_ sender: UIButton) {
        guard let applyUrl = viewModel.job.applyUrl?.treatUrl(), let url = URL(string: applyUrl) else {
            return
        }
        UIApplication.shared.open(url)
    }
}

extension JobViewController: WKNavigationDelegate {
    
}
