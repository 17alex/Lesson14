//
//  SecondViewController.swift
//  Lesson14
//
//  Created by Alex on 25.05.2021.
//

import UIKit

final class SecondViewController: UIViewController {

    //MARK: - Propertis
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - LiceCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Metods
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "City"
        view.addSubview(label)
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
