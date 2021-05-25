//
//  ViewController.swift
//  Lesson14
//
//  Created by Alex on 25.05.2021.
//

import UIKit

final class ViewController: UIViewController {

    //MARK: - Propertis
    
    var cities = [
        City(name: "Samara", isCheck: false),
        City(name: "Piter", isCheck: true),
        City(name: "Moscow", isCheck: false),
        City(name: "Vladivostok", isCheck: true),
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
        table.register(CityCell.self, forCellReuseIdentifier: "cell")
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
        
        let reorderItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(reorderButtonPress))
        navigationItem.leftBarButtonItem = reorderItem
        
        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func reorderButtonPress() {
        table.isEditing.toggle()
    }
    
    @objc func addButtonPress() {
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
    
    private func renameCityName(for index: Int) {
        showAlert(title: "Rename") { cityName in
            self.cities[index].name = cityName
            self.table.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CityCell
        cell.set(city: cities[indexPath.row])
        cell.delegate = self
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
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        cities.insert(cities.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completion) in
            self.cities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let renameAction = UIContextualAction(style: .normal, title: nil) { (_, _, complete) in
            self.renameCityName(for: indexPath.row)
            complete(true)
        }
        renameAction.image = UIImage(systemName: "pencil")
        renameAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [renameAction])
    }
}

//MARK: - CityCellProtocol

extension ViewController: CityCellProtocol {
    
    func didCheckPress(cell: UITableViewCell) {
        if let indexPath = table.indexPath(for: cell) {
            cities[indexPath.row].isCheck.toggle()
            table.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
