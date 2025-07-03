import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        let dropsVC = UINavigationController(rootViewController: DropsViewController())
        dropsVC.tabBarItem = UITabBarItem(title: "Drops", image: UIImage(systemName: "shippingbox"), tag: 0)

        let accountsVC = UINavigationController(rootViewController: AccountsViewController())
        accountsVC.tabBarItem = UITabBarItem(title: "Accounts", image: UIImage(systemName: "person.3"), tag: 1)

        let statsVC = UINavigationController(rootViewController: StatsViewController())
        statsVC.tabBarItem = UITabBarItem(title: "Stats", image: UIImage(systemName: "chart.bar"), tag: 2)

        viewControllers = [dropsVC, accountsVC, statsVC]
    }
}
