//
//  ViewController.swift
//  Lesson14
//
//  Created by Alex on 25.05.2021.
//

import UIKit

final class ViewController: UIViewController {

    //MARK: - Propertis
    
    private var cities = [
        City(name: "Samara", isCheck: false),
        City(name: "Piter", isCheck: false),
        City(name: "Moscow", isCheck: false),
        City(name: "Vladivostok", isCheck: false),
        City(name: "Ishim", isCheck: false),
        City(name: "Anapa", isCheck: false),
        City(name: "Murmansk", isCheck: false),
        City(name: "Tula", isCheck: false),
        City(name: "Novgorod", isCheck: false),
        City(name: "Kazan", isCheck: false)
    ]
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(CityCell.self, forCellReuseIdentifier: CityCell.reuseID)
        table.tableFooterView = UIView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - LiceCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Metods
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Cities"
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPress))
        navigationItem.rightBarButtonItem = addItem
        
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func addButtonPress() {
        showAlert(title: "Enter") { cityName in
            self.addNewCity(name: cityName)
        }
    }
    
    private func addNewCity(name: String) {
        cities.append(City(name: name, isCheck: false))
        let indexPath = IndexPath(row: cities.count - 1, section: 0)
        table.insertRows(at: [indexPath], with: .right)
        table.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    private func showAlert(title: String, complete: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            if let cityName = alert.textFields?.first?.text, !cityName.isEmpty {
                complete(cityName)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (textField) in
            textField.placeholder = "enter city name"
            textField.autocapitalizationType = .words
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.reuseID, for: indexPath) as! CityCell
        cell.set(city: cities[indexPath.row])
        cell.cellAction = { [weak self] cell in
            if let strongSelf = self,
               let indexPath = strongSelf.table.indexPath(for: cell) {
                strongSelf.cities[indexPath.row].isCheck.toggle()
                strongSelf.table.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = SecondViewController()
        secondVC.label.text = cities[indexPath.row].name
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
