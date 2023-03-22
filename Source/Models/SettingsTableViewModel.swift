//
// SettingsTableViewModel.swift
// Jodel EMPROVED
//
// Created By Natheer (@ExTBH) on 24/01/2023
//

import UIKit

enum SettingsTableViewClass: String {

    case navigationCell
    case switchCell

}

// URL's checked before classes
struct SettingsTableViewCellModel {
    let cellClass: SettingsTableViewClass
    let title: String
    let subTitle: String?
    let image: UIImage?
    let linkToOpen: URL?
    let classToPresent: UIViewController?
    let uniqueID: String?
    let disabled: Bool

    init(
        cellClass: SettingsTableViewClass,
        title: String,
        subTitle: String? = nil,
        image: UIImage? = nil,
        linkToOpen: URL? = nil,
        classToPresent: UIViewController? = nil,
        uniqueID: String? = nil,
        disabled: Bool = false) {
            self.cellClass = cellClass
            self.title = title
            self.subTitle = subTitle
            self.image = image
            self.linkToOpen = linkToOpen
            self.classToPresent = classToPresent
            self.uniqueID = uniqueID
            self.disabled = disabled
        }
}

struct SettingsTableViewSectionModel{
    let sectionTitle: String?
    let sectionFooter: String?
    let sectionRows: [SettingsTableViewCellModel]
    init(sectionTitle: String? = nil, sectionFooter: String? = nil, sectionRows: [SettingsTableViewCellModel]) {
        self.sectionTitle = sectionTitle
        self.sectionFooter = sectionFooter
        self.sectionRows = sectionRows
    }
}

struct SettingsTableViewModel {
    let tableFooter: UIView?
    let tableSections: [SettingsTableViewSectionModel]
    init(tableFooter: UIView? = nil, tableSections: [SettingsTableViewSectionModel]) {
        self.tableFooter = tableFooter
        self.tableSections = tableSections
    }
}