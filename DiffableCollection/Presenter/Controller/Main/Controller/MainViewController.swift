//
//  MainViewController.swift
//  DiffableCollection
//
//  Created by Fabrício Masiero on 29/04/20.
//  Copyright © 2020 Fabrício Masiero. All rights reserved.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: JobsViewModel
    private var jobs: [Job] = []
    private var switchSubscriber: AnyCancellable?
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        return searchController
    }()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: JobsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "JobTableViewCell", bundle: .main), forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.searchResultsUpdater = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getJobs()
    }
    private func getJobs() {
        viewModel.page = 1
        viewModel.search = ""
        viewModel.fetchJobs()
        
        switchSubscriber = viewModel.jobsSubject.sink(receiveCompletion: { event in
            print("event")
        }, receiveValue: { jobz in
            self.jobs = jobz
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
}
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(viewModel.getViewControllerToPresent(job: jobs[indexPath.row]), animated: true)
    }
}
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! JobTableViewCell
        cell.tag = indexPath.row
        cell.set(job: jobs[indexPath.row], indexPath: indexPath)
        return cell
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 2 {
            viewModel.search = text
            viewModel.fetchJobs()
        }
    }
}
extension MainViewController: UISearchControllerDelegate {
    
}
//extension MainViewController: NSDiffableDataSourceSnapshot<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable> {
    
//}
