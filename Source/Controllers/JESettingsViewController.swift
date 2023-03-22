//
// JESettingsViewController.swift
// Jodel EMPROVED
//
// Created By Natheer (@ExTBH) on 23/01/2023
//

import UIKit

enum JETheme {
    static let tableBackgroundColor = "uiListBackgroundColor"
    static let cellBackgroundColor = "uiContainerColor"
    static let cellTextColor = "uiContainerTextColor"
}


@objc final public class JESettingsViewController : UIViewController {
    let tableView = UITableView(frame: CGRect(), style: .insetGrouped)
    var tableModel: SettingsTableViewModel!

    @objc public override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        tableModel = tableData()
    }

    private func prepare() -> Void {
        view.backgroundColor = .init(named: JETheme.tableBackgroundColor)
        title = "Jodel EMPROVED"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 50
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .init(named: JETheme.tableBackgroundColor)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didRefresh), for: .valueChanged)

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    private func tableData() -> SettingsTableViewModel {
        let locationSpoofer = SettingsTableViewCellModel(
            cellClass: .switchCell,
            title: "Locaion Spoofer",
            subTitle: "refresh feed to take effect.",
            uniqueID: "kLocationSpoofer")

        let general = SettingsTableViewSectionModel(sectionTitle: "General", sectionRows: [locationSpoofer])

        let screenshotProtection = SettingsTableViewCellModel(
            cellClass: .switchCell,
            title: "Screenshot Protection",
            subTitle: "disables screenshot notifications.",
            uniqueID: "kScreenshotProtection")

        let protection = SettingsTableViewSectionModel(sectionTitle: "Protection", sectionRows: [screenshotProtection])
        
        let github = SettingsTableViewCellModel(
            cellClass: .navigationCell,
            title: "Github",
            subTitle: "source code on Github",
            linkToOpen: URL(string: "https://github.com/ExTBH/JodelEMPROVED"))
        
        let twitter = SettingsTableViewCellModel(
            cellClass: .navigationCell,
            title: "Twitter",
            subTitle: "anything other than you're banned :)",
            linkToOpen: URL(string: "https://twitter.com/ExTBH/"))
        
        let info = SettingsTableViewSectionModel(sectionTitle: "Info", sectionRows: [github, twitter])

        let model = SettingsTableViewModel(tableSections: [general, protection, info])

        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SettingsTableViewClass.switchCell.rawValue)
        tableView.register(NavigationTableViewCell.self, forCellReuseIdentifier: SettingsTableViewClass.navigationCell.rawValue)

        return model
    }

}

// MARK: TableView Functions
extension JESettingsViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return tableModel.tableSections.count
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableModel.tableSections[section].sectionTitle
    }
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return tableModel.tableSections[section].sectionFooter
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.tableSections[section].sectionRows.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel!.tableSections[indexPath.section].sectionRows[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellClass.rawValue, for: indexPath) as! (UITableViewCell & SettingsTableViewCellProtocol)
        
        cell.populate(with: cellModel)
        
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! (UITableViewCell & SettingsTableViewCellNavigationProtocol)
        tableView.deselectRow(at: indexPath, animated: true)
        cell.selected(with: tableModel.tableSections[indexPath.section].sectionRows[indexPath.row])
    }

}

// MARK: Selectors
extension JESettingsViewController {
    @objc func didRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [weak self] in
        guard let self = self else { return }
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}