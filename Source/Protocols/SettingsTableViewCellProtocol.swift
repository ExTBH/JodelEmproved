//
// SettingsTableViewCellProtocol.swift
// Jodel EMPROVED
//
// Created By Natheer (@ExTBH) on 24/01/2023
//

import UIKit


protocol SettingsTableViewCellProtocol {
    func populate(with cellModel: SettingsTableViewCellModel) -> Void
}

protocol SettingsTableViewCellNavigationProtocol {
    func selected(with cellModel: SettingsTableViewCellModel) -> Void
}