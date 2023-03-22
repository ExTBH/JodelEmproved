//
// SwitchTableViewCell.swift
// Jodel EMPROVED
//
// Created By Natheer (@ExTBH) on 24/01/2023
//

import UIKit

final class SwitchTableViewCell: BaseSettingsTableViewCell, SettingsTableViewCellProtocol {
    private var defaultsKey: String!
    private let switchView: UISwitch
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.switchView = UISwitch()
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        switchView.addTarget(self, action: #selector(flippedSwitch), for: .valueChanged)
        accessoryView = switchView
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func populate(with cellModel: SettingsTableViewCellModel) {
        defaultsKey = cellModel.uniqueID
        textLabel?.text = cellModel.title
        detailTextLabel?.text = cellModel.subTitle
        if let defaultsKey = cellModel.uniqueID {
            switchView.isOn = UserDefaults.standard.bool(forKey: defaultsKey)
        }
        
    }

    @objc private func flippedSwitch() {
        guard let defaultsKey = defaultsKey else {
            switchView.setOn(!switchView.isOn, animated: true)
            return
        }
        UserDefaults.standard.set(switchView.isOn, forKey: defaultsKey)
    }
}