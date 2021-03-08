import UIKit

class MenuViewController: UIViewController {
  private var presenter: TimestampListPresenter!
  private let slidingView = UIView()
  private let slidingViewWidth: CGFloat = 150
  private var slidingViewRightConstraint: NSLayoutConstraint!
  private var slidingViewLeftConstraint: NSLayoutConstraint!
  private let dismissView = UIView()
  private var timeView: TimeView!
  private var viewModel: TimestampListViewModel? { didSet { updateView() }}

  class func make() -> MenuViewController {
    let menuViewController = MenuViewController()
    let useCase = TimestampListUseCase()
    let presenter = TimestampListPresenter(useCase: useCase)
    useCase.observer = presenter
    presenter.view = menuViewController
    menuViewController.presenter = presenter
    menuViewController.timeView = TimeView.make { [weak menuViewController] in menuViewController?.requestNewTimestamp() }
    menuViewController.setupView()
    return menuViewController
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    updateView()
    showSlidingView()
  }

  private func setupView() {
    view.backgroundColor = .clear

    setupSlidingView()
    setupTimeView()
    setupDismissView()
  }

  private func setupSlidingView() {
    slidingView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    slidingView.backgroundColor = .blue
    view.addSubview(slidingView)
    slidingView.translatesAutoresizingMaskIntoConstraints = false
    slidingViewRightConstraint = slidingView.rightAnchor.constraint(equalTo: view.leftAnchor)
    slidingViewLeftConstraint = slidingView.leftAnchor.constraint(equalTo: view.leftAnchor)
    slidingViewLeftConstraint.priority = .defaultLow
    NSLayoutConstraint.activate([
      slidingView.widthAnchor.constraint(equalToConstant: 200),
      slidingViewRightConstraint,
      slidingView.topAnchor.constraint(equalTo: view.topAnchor),
      slidingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  private func setupTimeView() {
    slidingView.addSubview(timeView)
    timeView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      timeView.rightAnchor.constraint(equalTo: slidingView.layoutMarginsGuide.rightAnchor),
      timeView.leftAnchor.constraint(equalTo: slidingView.layoutMarginsGuide.leftAnchor),
      timeView.topAnchor.constraint(equalTo: slidingView.layoutMarginsGuide.topAnchor),
      timeView.heightAnchor.constraint(equalToConstant: 175),
    ])
  }

  private func setupDismissView() {
    dismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideSlidingViewAndDismiss)))
    view.addSubview(dismissView)
    dismissView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dismissView.rightAnchor.constraint(equalTo: view.rightAnchor),
      dismissView.leftAnchor.constraint(equalTo: slidingView.rightAnchor),
      dismissView.topAnchor.constraint(equalTo: view.topAnchor),
      dismissView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  private func showSlidingView() {
    slidingViewRightConstraint.isActive = false
    slidingViewLeftConstraint.isActive = true
    UIView.animate(withDuration: 0.25) { [weak self] in
      self?.view.layoutIfNeeded()
    }
  }

  @objc private func hideSlidingViewAndDismiss() {
    slidingViewRightConstraint.isActive = true
    slidingViewLeftConstraint.isActive = false
    UIView.animate(withDuration: 0.25,
                   animations: { [weak self] in
                     self?.view.layoutIfNeeded()
                   },
                   completion: { [weak self] _ in
                     self?.view.removeFromSuperview()
                     self?.dismiss(animated: false)
                   })
  }

  private func updateView() {
    guard isViewLoaded else { return }
    timeView.viewModel = TimeViewModel(timestamps: viewModel?.timestamps ?? [])
  }

  private func requestNewTimestamp() {
    presenter.requestNewTimestamp()
  }
}

// MARK: - TimestampListView
extension MenuViewController: TimestampListView {

  func update(withModel viewModel: TimestampListViewModel) {
    self.viewModel = viewModel
  }
}
