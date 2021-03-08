import UIKit

class MainViewController: UIViewController {
  private var presenter: TimestampListPresenter!
  private var viewModel: TimestampListViewModel? { didSet { updateView() }}
  private let menuButton = UIButton(type: .system)
  private var timeView: TimeView!
  private var popupView: PopupView!
  private let menuViewController = MenuViewController.make()

  class func make() -> MainViewController {
    let mainViewController = MainViewController()
    let useCase = TimestampListUseCase()
    let presenter = TimestampListPresenter(useCase: useCase)
    useCase.observer = presenter
    presenter.view = mainViewController
    mainViewController.presenter = presenter
    mainViewController.timeView = TimeView.make { [weak mainViewController] in mainViewController?.requestNewTimestamp() }
    mainViewController.popupView = PopupView.make { [weak mainViewController] in mainViewController?.requestNewTimestamp() }
    mainViewController.setupView()
    return mainViewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    updateView()
  }

  private func setupView() {
    view.backgroundColor = .green

    menuButton.addTarget(self, action: #selector(showMenu), for: .primaryActionTriggered)
    menuButton.setTitle("Menu", for: .normal)
    menuButton.setTitleColor(.systemBlue, for: .normal)
    view.addSubview(menuButton)
    menuButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      menuButton.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
      menuButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
    ])

    view.addSubview(timeView)
    timeView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      timeView.widthAnchor.constraint(equalToConstant: 175),
      timeView.heightAnchor.constraint(equalToConstant: 175),
      timeView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
      timeView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
    ])

    view.addSubview(popupView)
    popupView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      popupView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
      popupView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
      popupView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
      popupView.heightAnchor.constraint(equalToConstant: 400),
    ])
  }

  @objc private func showMenu() {
    addChild(menuViewController)
    view.addFillerSubview(menuViewController.view)
  }

  private func updateView() {
    guard isViewLoaded else { return }
    let timeViewModel = TimeViewModel(timestamps: viewModel?.timestamps ?? [])
    timeView.viewModel = timeViewModel
    popupView.updateTimeStamps(timeViewModel: timeViewModel)
  }

  private func requestNewTimestamp() {
    presenter.requestNewTimestamp()
  }
}

// MARK: - TimestampListView
extension MainViewController: TimestampListView {

  func update(withModel viewModel: TimestampListViewModel) {
    self.viewModel = viewModel
  }
}
