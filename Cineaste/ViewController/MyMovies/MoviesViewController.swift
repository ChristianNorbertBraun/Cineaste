//
//  MoviesViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

class MoviesViewController: UIViewController {
    var category: MovieListCategory = .wantToSee {
        didSet {
            title = category.title
            emptyListLabel.text = Strings.title(for: category)

            //only update if category changed
            guard oldValue != category else { return }
            if fetchedResultsManager.controller == nil {
                fetchedResultsManager.setup(with: category.predicate) {
                    self.myMoviesTableView.reloadData()
                }
            } else {
                fetchedResultsManager.refetch(for: category.predicate) {
                    self.myMoviesTableView.reloadData()
                }
            }
        }
    }

    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet var myMoviesTableView: UITableView! {
        didSet {
            myMoviesTableView.dataSource = self
            myMoviesTableView.delegate = self

            myMoviesTableView.tableFooterView = UIView()
            myMoviesTableView.backgroundColor = UIColor.basicBackground

            myMoviesTableView.rowHeight = UITableViewAutomaticDimension
            myMoviesTableView.estimatedRowHeight = 80
        }
    }

    let fetchedResultsManager = FetchedResultsManager()
    var storageManager: MovieStorage?
    var selectedMovie: StoredMovie?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.basicBackground

        fetchedResultsManager.delegate = self
        fetchedResultsManager.setup(with: category.predicate) {
            self.myMoviesTableView.reloadData()
            self.hideTableView(self.fetchedResultsManager.controller?.fetchedObjects?.isEmpty)
        }

        registerForPreviewing(with: self, sourceView: myMoviesTableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        hideTableView(fetchedResultsManager.controller?.fetchedObjects?.isEmpty)
    }

    @IBAction func triggerSearchMovieAction(_ sender: UIBarButtonItem) {
        perform(segue: .showSearchFromMovieList, sender: self)
    }

    func hideTableView(_ isEmpty: Bool?, handler: (() -> Void)? = nil) {
        let isEmpty = isEmpty ?? true

        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    self.myMoviesTableView.alpha = isEmpty ? 0 : 1
            },
                completion: { _ in
                    self.myMoviesTableView.isHidden = isEmpty
                    handler?()
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showSearchFromMovieList?:
            let navigationVC = segue.destination as? UINavigationController
            let vc = navigationVC?.viewControllers.first as? SearchMoviesViewController
            vc?.storageManager = storageManager
        case .showMovieDetail?:
            let vc = segue.destination as? MovieDetailViewController
            vc?.storedMovie = selectedMovie
            vc?.storageManager = storageManager
            vc?.type = (category == MovieListCategory.seen) ? .seen : .wantToSee
        default:
            break
        }
    }

    private func updateShortcutItems() {
        guard let movies = self.fetchedResultsManager.controller?.fetchedObjects else {
            return
        }

        var shortcuts = UIApplication.shared.shortcutItems ?? []

        //initially instantiate shortcuts
        if shortcuts.isEmpty {
            let wantToSeeIcon = UIApplicationShortcutIcon(templateImageName: "add_to_watchlist")
            let wantToSeeShortcut = UIApplicationShortcutItem(type: ShortcutIdentifier.wantToSeeList.rawValue,
                                                          localizedTitle: Strings.wantToSeeList,
                                                          localizedSubtitle: nil,
                                                          icon: wantToSeeIcon,
                                                          userInfo: nil)

            let seenIcon = UIApplicationShortcutIcon(templateImageName: "add_to_watchedlist")
            let seenShortcut = UIApplicationShortcutItem(type: ShortcutIdentifier.seenList.rawValue,
                                                     localizedTitle: Strings.seenList,
                                                     localizedSubtitle: nil,
                                                     icon: seenIcon,
                                                     userInfo: nil)

            shortcuts = [wantToSeeShortcut, seenShortcut]
            UIApplication.shared.shortcutItems = shortcuts
        }

        let index = category == .wantToSee ? 0 : 1
        let existingItem = shortcuts[index]

        //only update if value changed
        if existingItem.localizedSubtitle != shortcutSubtitle(for: movies.count) {
            //swiftlint:disable:next force_cast
            let mutableShortcutItem = existingItem.mutableCopy() as! UIMutableApplicationShortcutItem
            mutableShortcutItem.localizedSubtitle = shortcutSubtitle(for: movies.count)

            shortcuts[index] = mutableShortcutItem

            UIApplication.shared.shortcutItems = shortcuts
        }
    }

    private func shortcutSubtitle(for numberOfMovies: Int) -> String? {
        switch numberOfMovies {
        case 0:
            return nil
        case 1:
            return "1 " + Strings.oneMovieShortCut
        case 2...:
            return "\(numberOfMovies) " + Strings.movieCounterShortCut
        default:
            return nil
        }
    }
}

// MARK: - UITableViewDataSource

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsManager.controller?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.identifier, for: indexPath) as? MovieListCell
            else {
                fatalError("Unable to dequeue cell for identifier: \(MovieListCell.identifier)")
        }

        if let controller = fetchedResultsManager.controller {
            cell.configure(with: controller.object(at: indexPath))
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let movies = fetchedResultsManager.controller?.fetchedObjects else {
            fatalError("Failure in loading fetchedObject")
        }
        selectedMovie = movies[indexPath.row]

        perform(segue: .showMovieDetail, sender: nil)
    }
}

// MARK: - FetchedResultsManagerDelegate

extension MoviesViewController: FetchedResultsManagerDelegate {
    func beginUpdate() {
        myMoviesTableView.beginUpdates()
    }
    func insertRows(at index: [IndexPath]) {
        myMoviesTableView.insertRows(at: index, with: .fade)
    }
    func deleteRows(at index: [IndexPath]) {
        myMoviesTableView.deleteRows(at: index, with: .fade)
    }
    func updateRows(at index: [IndexPath]) {
        myMoviesTableView.reloadRows(at: index, with: .fade)
    }
    func moveRow(at index: IndexPath, to newIndex: IndexPath) {
        myMoviesTableView.moveRow(at: index, to: newIndex)
    }
    func endUpdate() {
        myMoviesTableView.endUpdates()
        hideTableView(fetchedResultsManager.controller?.fetchedObjects?.isEmpty)
        updateShortcutItems()
    }
}

// MARK: - 3D Touch

extension MoviesViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let detailVC = MovieDetailViewController.instantiate()
        guard let path = myMoviesTableView.indexPathForRow(at: location),
            let objects = fetchedResultsManager.controller?.fetchedObjects,
            objects.count > path.row
            else { return nil }

        let movie = objects[path.row]
        detailVC.storedMovie = movie
        detailVC.storageManager = storageManager
        detailVC.type = (category == MovieListCategory.seen) ? .seen : .wantToSee
        return detailVC
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}

// MARK: - Instantiable

extension MoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .movieList }
    static var storyboardID: String? { return "MoviesViewController" }
}
