//
//  SettingsViewController+UITableView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit
import MessageUI

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeueCell(identifier: SettingsCell.identifier)
        cell.configure(with: settings[indexPath.row])
        return cell
    }

    // swiftlint:disable:next cyclomatic_complexity
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        selectedSetting = settings[indexPath.row]
        guard let setting = selectedSetting else { return }

        switch setting {
        case .about, .licence:
            guard let segue = setting.segue else { return }
            perform(segue: segue, sender: self)
        case .language:
            guard let url = URL(string: UIApplication.openSettingsURLString)
                else { fatalError("Expected a valid URL") }
            UIApplication.shared.open(url, options: [:])
        case .exportMovies:
            exportMovies(showUIOn: tableView.rectForRow(at: indexPath))
        case .importMovies:
            importMovies()
        case .contact:
            let actionSheet = UIAlertController(
                title: .contactTitle,
                message: nil,
                preferredStyle: .actionSheet
            )

            let email = UIAlertAction(title: "\(String.emailTo) \(Constants.emailAddress)", style: .default) { _ in

                if #available(iOS 14.0, *),
                   let url = URL(string: "mailto:\(Constants.emailAddress)"),
                   UIApplication.shared.canOpenURL(url) {
                    /// this respects iOS 14 default mail app settings
                    /// and opens the default app
                    UIApplication.shared.open(url, options: [.universalLinksOnly: false])
                } else if MFMailComposeViewController.canSendMail() {
                    /// this opens the "Mail" app, if an account is configured
                    let mailComposeVC = MFMailComposeViewController()
                    mailComposeVC.mailComposeDelegate = self
                    mailComposeVC.setSubject("Cineaste iOS || \(String.versionText): \(Constants.versionNumberInformation)")
                    mailComposeVC.setToRecipients([Constants.emailAddress])

                    self.present(mailComposeVC, animated: true)
                } else {
                    /// this copies the email address to pasteboard
                    /// and user can decide what to do
                    let pasteBoard = UIPasteboard.general
                    pasteBoard.string = Constants.emailAddress

                    let alert = UIAlertController(title: .copiedEmailAddress, message: nil, preferredStyle: .alert)
                    self.present(alert, animated: true) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            alert.dismiss(animated: true)
                        }
                    }
                }
            }
            actionSheet.addAction(email)

            if let url = URL(string: Constants.gitHubRepo) {
                let github = UIAlertAction(title: .linkToGitHub, style: .default) { _ in
                    let safariVC = CustomSafariViewController(url: url)
                    self.present(safariVC, animated: true)
                }
                actionSheet.addAction(github)
            }

            let cancel = UIAlertAction(title: .cancelAction, style: .cancel)
            actionSheet.addAction(cancel)

            // to display action sheet correctly on iPad
            if let cell = tableView.cellForRow(at: indexPath) {
                actionSheet.popoverPresentationController?.sourceView = cell
                actionSheet.popoverPresentationController?.sourceRect = CGRect(
                    x: cell.bounds.midX,
                    y: cell.bounds.midY,
                    width: 0,
                    height: 0
                )
            }

            present(actionSheet, animated: true)
        case .appStore:
            AppStoreReview.openWriteReviewURL()
        }
    }
}
