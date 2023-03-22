//
// BaseSettingsTableViewCell.swift
// Jodel EMPROVED
//
// Created By Natheer (@ExTBH) on 25/01/2023
//

import UIKit


class BaseSettingsTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        textLabel?.font = .init(name: "Gotham-Book", size: 16)
        textLabel?.textColor = .init(named: JETheme.cellTextColor)
        detailTextLabel?.font = .init(name: "Gotham-Book", size: 10)
        detailTextLabel?.textColor = .tertiaryLabel
        backgroundColor = .init(named: JETheme.cellBackgroundColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}