//
//  SettingsViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet private weak var footerView: UIView!
    @IBOutlet private weak var versionInfo: DescriptionLabel! {
        didSet {
            versionInfo.textColor = .accentTextOnBlack
        }
    }

    let settings = SettingItem.allCases
    var selectedSetting: SettingItem?

    lazy var fetchedResultsManager = FetchedResultsManager()
    var storageManager: MovieStorage?
    var docController: UIDocumentInteractionController?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = String.settingsTitle

        tableView.backgroundColor = UIColor.basicBackground
        tableView.tableFooterView = footerView

        versionInfo?.text = Constants.versionNumberInformation
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showTextViewFromSettings?:
            guard let selected = selectedSetting else { return }

            let vc = segue.destination as? SettingsDetailViewController
            vc?.configure(with: selected.title,
                          textViewContent: selected == .licence ? .licence : .imprint)
        default:
            return
        }
    }

    // MARK: - Import and Export

    func importMovies() {
        fetchedResultsManager.refetch()

        let documentPickerVC = UIDocumentPickerViewController(documentTypes: [String.exportMoviesFileUTI],
                                                              in: .import)
        documentPickerVC.delegate = self

        if #available(iOS 11.0, *) {
            documentPickerVC.allowsMultipleSelection = false
        }

        present(documentPickerVC, animated: true)
    }

    func exportMovies(to path: URL, on rect: CGRect) {
        saveMoviesLocally()

        docController = UIDocumentInteractionController(url: path)
        docController?.uti = String.exportMoviesFileUTI
        docController?.presentOptionsMenu(from: rect, in: view, animated: true)
    }

    private func saveMoviesLocally() {
        fetchedResultsManager.refetch()

        guard !fetchedResultsManager.movies.isEmpty else {
            //database is empty, inform user that an export is not useful
            showAlert(withMessage: Alert.exportEmptyData)
            return
        }

        do {
            try Exporter.export(fetchedResultsManager.movies)
        } catch {
            showAlert(withMessage: Alert.exportFailedInfo)
        }
    }
}

extension SettingsViewController: Instantiable {
    static var storyboard: Storyboard { return .settings }
    static var storyboardID: String? { return "SettingsViewController" }
}
