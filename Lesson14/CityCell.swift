//
//  CustomCell.swift
//  Lesson14
//
//  Created by Alex on 25.05.2021.
//

import UIKit

final class CityCell: UITableViewCell {

    //MARK: - Propertis
    
    var cellAction: ((CityCell) -> Void)?
    
     private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var chekButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(checkButtonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(chekButton)
        
        NSLayoutConstraint.activate([
            cityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cityNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cityNameLabel.trailingAnchor.constraint(equalTo: chekButton.leadingAnchor, constant: -16),
            
            chekButton.centerYAnchor.constraint(equalTo: cityNameLabel.centerYAnchor),
            chekButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chekButton.widthAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Metods
    
    @objc private func checkButtonPress() {
        cellAction?(self)
    }
    
    func set(city: City) {
        cityNameLabel.text = city.name
        contentView.backgroundColor = city.isCheck ? .systemGreen : .white
        let image = UIImage(systemName: city.isCheck ? "checkmark.circle" : "circle")
        chekButton.setImage(image, for: .normal)
    }
}
