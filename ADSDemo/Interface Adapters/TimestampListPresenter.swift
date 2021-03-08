import Foundation

struct TimestampListViewModel: Equatable {
  let timestamps: [String]
}

protocol TimestampListView: AnyObject {
  func update(withModel: TimestampListViewModel)
}

class TimestampListPresenter {
  private let useCase: TimestampListUseCase
  private var timestamps: [Date] = [] { didSet { updateView() }}
  weak var view: TimestampListView? { didSet { updateView() }}

  init(useCase: TimestampListUseCase) {
    self.useCase = useCase
  }

  func requestNewTimestamp() {
    useCase.generateTimestamp()
  }

  private func updateView() {
    view?.update(withModel: TimestampListViewModel(timestamps: timestamps))
  }
}

// MARK: - TimestampListUseCaseObserver
extension TimestampListPresenter: TimestampListUseCaseObserver {

  func updateTimeStamps(timestamps: [Date]) {
    self.timestamps = timestamps
  }
}

// MARK: - ViewModel Init
extension TimestampListViewModel {

  fileprivate init(timestamps: [Date]) {
    self.timestamps = timestamps.map { $0.description }.reversed()
  }
}
