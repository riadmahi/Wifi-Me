//
//  MyWifiController.swift
//  Wifi&Me
//
//  Created by Riad Mahi on 21/11/2022.
//

import UIKit

class MyWifiController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var boxName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var boxImage: UIImageView!

    private let networkCellsName = ["ID produit", "Numéro de série", "Référence client", "Tension Alim", "Température", "Net mode", "Adresse MAC", "Version bootloader", "Version mainfirmware", "Version DSL Driver", "idur"]
    
    private var network: Network!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getWifiInfo()
    }
    
    private func getWifiInfo() {
        guard let url = URL(string: "http://192.168.1.1/api/1.0/?method=system.getInfo") else { return }
        URLSession.shared.dataTask(with: url) {(data, _, error) in
            guard let data = data else { return }
            let transformer = INOXMLTransformer(withData: data)
            let dictionary = transformer.toDictionary()
            let conversion = ConvertDictionary(withData: dictionary)
            do {
                let network = try conversion.convertDictionaryToNetwork()
                DispatchQueue.main.async {
                    self.setupWidgets(network)
                    self.network = network
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    @IBAction func reloadWifiInfo() {
        self.getWifiInfo()
    }
    
    private func setupWidgets(_ network: Network) {
        boxName.text = network.boxImageName
        timeLabel.text = network.currentDate
        guard let box: UIImage = UIImage(named: network.boxImageName) else { return }
        boxImage.image = box
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkCellsName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkInfoCell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = networkCellsName[indexPath.row]
        contentConfiguration.secondaryText = getCorrespondingCellInfo(at: indexPath.row)
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .title3)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        contentConfiguration.textProperties.color = .gray
        cell.contentConfiguration = contentConfiguration
        return cell
    }
    
    private func getCorrespondingCellInfo(at index: Int) -> String {
        guard let net = network else { return "null" }
        let info: String = {
            switch index {
            case 0:
                return net.productID
            case 1:
                return net.serialNumber
            case 2:
                return net.refclient
            case 3:
                return net.alimvoltage
            case 4:
                return net.temperature
            case 5:
                return net.netMode
            case 6:
                return net.macAdresse
            case 7:
                return net.versionBootloader
            case 8:
                return net.versionMainfirmware
            case 9:
                return net.versionDsldriver
            case 10:
                return net.idur
            default:
                return "N/A"
            }
        }()
        return info
    }
}
