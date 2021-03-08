import UIKit

struct TimeViewModel {
  let timestamps: [String]

  func timestamp(atIndex index: Int) -> String? {
    guard timestamps.count > index else { return nil }
    return timestamps[index]
  }
}

class TimeView: UIView {
  private var buttonAction: (() -> Void)!
  private let button = UIButton(type: .system)
  private let tableView = UITableView()

  var viewModel: TimeViewModel? { didSet { update() } }

  class func make(buttonAction: @escaping () -> Void) -> TimeView {
    let timeView = TimeView()
    timeView.buttonAction = buttonAction
    timeView.setupView()
    return timeView
  }

  private func update() {
    tableView.reloadData()
  }

  private func setupView() {
    backgroundColor = .white
    setupButton()
    setupTableView()
  }

  private func setupButton() {
    button.addTarget(self, action: #selector(doButtonAction), for: .primaryActionTriggered)

    button.setTitle("Button", for: .normal)
    button.setTitleColor(.black, for: .normal)
    addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor),
      button.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor),
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      button.topAnchor.constraint(equalTo: topAnchor),
    ])
  }

  private func setupTableView() {
    setupTableViewDataSource()

    addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor),
      tableView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor),
      tableView.topAnchor.constraint(equalTo: button.bottomAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  @objc private func doButtonAction() {
    buttonAction()
  }
}

// MARK: - UITableViewDataSource
extension TimeView: UITableViewDataSource {

  private class LabelledCell: UITableViewCell {
    static let reuseIdentifier = String(describing: self)
    let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: .default, reuseIdentifier: Self.reuseIdentifier)
      label.textColor = .black
      label.font = .systemFont(ofSize: 15)
      contentView.addFillerSubview(label)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func update(title: String) {
      label.text = title
    }
  }

  func setupTableViewDataSource() {
    tableView.dataSource = self
    tableView.register(LabelledCell.self, forCellReuseIdentifier: LabelledCell.reuseIdentifier)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.timestamps.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelledCell.reuseIdentifier) as? LabelledCell,
          let cellTitle = viewModel?.timestamp(atIndex: indexPath.row)
    else { return UITableViewCell() }

    cell.update(title: cellTitle)
    return cell
  }
}
