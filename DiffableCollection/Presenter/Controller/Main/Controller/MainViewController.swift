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
//        let publi
//        switchSubscriber = viewModel.$jobs.receive(subscriber: T##Subscriber)
//        switchSubscriber = viewModel.$jobs.receive(on: DispatchQueue.main).subs
        viewModel.fetchJobs()
        
//        switchSubscriber = viewModel.$jobs.receive(on: DispatchQueue.main).assign(to: \[Job] as! ReferenceWritableKeyPath<[Job], Published<[Job]>.Publisher.Output>, on: jobs)
//        let what = viewModel.jobsSubject.subscribe(on: DispatchQueue.main).assign(to: \JobsViewModel.jobs, on: viewModel)
        
        switchSubscriber = viewModel.jobsSubject.sink(receiveCompletion: { event in
            print("event")
        }, receiveValue: { jobz in
            self.jobs = jobz
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
//        viewModel.jobsSubject.sub
//        print(teste.)
    }
}
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = JobViewModel(job: jobs[indexPath.row])
        let jobViewController = JobViewController(nibName: "JobViewController", bundle: .main, viewModel: viewModel)
        navigationController?.pushViewController(jobViewController, animated: true)
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
        viewModel.search = text
        viewModel.fetchJobs()
        print(text)
    }
}
extension MainViewController: UISearchControllerDelegate {
    
}
//extension MainViewController: NSDiffableDataSourceSnapshot<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable> {
    
//}
