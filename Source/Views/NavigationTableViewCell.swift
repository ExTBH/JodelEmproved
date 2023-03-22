//
// NavigationTableViewCell.swift
// Jodel EMPROVED
//
// Created By Natheer (@ExTBH) on 24/01/2023
//

import UIKit

final class NavigationTableViewCell: BaseSettingsTableViewCell, SettingsTableViewCellProtocol {
    private var defaultsKey: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func populate(with cellModel: SettingsTableViewCellModel) {
        defaultsKey = cellModel.uniqueID
        textLabel?.text = cellModel.title
        detailTextLabel?.text = cellModel.subTitle
    }

}
extension NavigationTableViewCell: SettingsTableViewCellNavigationProtocol {
    func selected(with cellModel: SettingsTableViewCellModel) {
        if let url = cellModel.linkToOpen {
            UIApplication.shared.open(url)
        }
    }
}