//
//  CakeListViewController.swift
//  CakeItApp
//
//  Created by David McCallum on 20/01/2021.
//

import UIKit

enum CakeTableViewSection {
    case main
}

let cakeListViewControllerTitle = "🎂CakeItApp🍰"

class CakeListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!

    var dataSource: UITableViewDiffableDataSource<CakeTableViewSection, Cake>! = nil
    
    var cakes: [Cake] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCakeList()
        registerTableViewCell()
        tableView.delegate = self
        
        title = cakeListViewControllerTitle
        
        dataSource = UITableViewDiffableDataSource<CakeTableViewSection, Cake>(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, item: Cake) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CakeListTableViewCellID") as! CakeListTableViewCell
            cell.titleLabel.text = item.title
            cell.descLabel.text = item.desc
            cell.cakeImageView.image = item.Orginalimage
            
            ImageCache.publicCache.loadCakeImages(url: URL(string: item.image)! as NSURL, item: item) { (fetchedItem, image) in
                if let img = image, img != fetchedItem.Orginalimage {
                    var updatedSnapshot = self.dataSource.snapshot()
                    if let datasourceIndex = updatedSnapshot.indexOfItem(fetchedItem) {
                        let item = self.cakes[datasourceIndex]
                        item.Orginalimage = img
                        updatedSnapshot.reloadItems([item])
                        self.dataSource.apply(updatedSnapshot, animatingDifferences: false)
                    }
                }
            }
            return cell
        }
    }
    
    func registerTableViewCell() {
        CakeListTableViewCell.registerTableViewCell(tableView: tableView)
        tableView.estimatedRowHeight = 250
    }
    
    func getCakeList() {
        CakeListEndpoint.getCakeList() {(cakes, errorMessge) in
            if let error = errorMessge {
                DispatchQueue.main.async {
                    self.showAlert(message: error)
                }
                return
            }
            if let cakes = cakes {
                self.cakes = cakes
                var initialSnapshot = NSDiffableDataSourceSnapshot<CakeTableViewSection, Cake>()
                initialSnapshot.appendSections([.main])
                initialSnapshot.appendItems(self.cakes)
                self.dataSource.apply(initialSnapshot, animatingDifferences: true)
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Sorry!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            print("Error alert shown with messge \(message)")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


extension CakeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCake = dataSource.itemIdentifier(for: indexPath)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let cakeDetailVC = storyBoard.instantiateViewController(withIdentifier: "CakeDetailVC") as! CakeDetailViewController
        cakeDetailVC.selectedCake = selectedCake
        self.navigationController?.pushViewController(cakeDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
