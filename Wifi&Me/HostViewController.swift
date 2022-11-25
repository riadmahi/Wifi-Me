//
//  NetworkViewController.swift
//  Wifi&Me
//
//  Created by Riad Mahi on 23/11/2022.
//

import UIKit

class HostViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    private var hosts: Hosts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getHostsList()
        #if os(iOS)
            self.configureRefreshControl()
        #endif
    }
    
    private func getHostsList() {
        guard let url = URL(string: "http://192.168.1.1/api/1.0/?method=lan.getHostsList") else { return }
        URLSession.shared.dataTask(with: url) {(data, _, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8) ?? "")
            let transformer = INOXMLTransformer(withData: data)
            let dictionary = transformer.toDictionary()
            print(dictionary?.description ?? "")
            let conversion = ConvertDictionary(withData: dictionary)
            do {
                var hosts = try conversion.convertDictionaryToHosts()
                DispatchQueue.main.async {
                    hosts.hostsList = hosts.hostsList.filter { host in return host.name != "" }
                    hosts.hostsList = hosts.hostsList.sorted { $0.isActive != $1.isActive }
                    hosts.hostsList = hosts.hostsList.reversed()
                    self.hosts = hosts
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
                
            }
        }.resume()
    }
    
    func configureRefreshControl () {
        #if os(iOS)
            self.tableView.refreshControl = UIRefreshControl()
            self.tableView.refreshControl?.addTarget(self, action:
                                              #selector(handleRefreshControl),
                                              for: .valueChanged)
        #endif
    }
    
    @objc func handleRefreshControl() {
        #if os(iOS)
            self.getHostsList()
            DispatchQueue.main.async {
              self.tableView.refreshControl?.endRefreshing()
            }
        #endif
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let nbHosts = hosts?.hostsList.count else { return 0 }
        return nbHosts
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HostInfoCell", for: indexPath) as? HostTableViewCell {
            if let host = hosts?.hostsList[indexPath.row] {
                cell.name.text = host.name
                cell.status.text = (host.isActive ? NSLocalizedString("host.isActive.true", tableName: "Localizable", comment: "isActive") : NSLocalizedString("host.isActive.false", tableName: "Localizable", comment: "isNotActive"))
                cell.statusDot.backgroundColor = host.isActive ? .green : .gray
                cell.statusDot.layer.cornerRadius = 10
                cell.contentView.alpha = host.isActive ? 1 : 0.4
                cell.deviceImage.image = host.type == TypeHost.PC ? UIImage(named: "monitor") : UIImage(named: "mobile")
                cell.deviceImage.image = cell.deviceImage.image?.withRenderingMode(.alwaysTemplate)
                cell.deviceImage.tintColor = .label
                return cell
            }
        }
        return UITableViewCell()
    }
}
