import Foundation

protocol TimestampListUseCaseObserver: AnyObject {
  func updateTimeStamps(timestamps: [Date])
}

class TimestampListUseCase {
  private weak var timestampGenerator: TimestampGenerator?
  public weak var observer: TimestampListUseCaseObserver? { didSet { updateObserver() }}

  init(timestampGenerator: TimestampGenerator = .shared) {
    self.timestampGenerator = timestampGenerator
    timestampGenerator.addObserver(self)
  }

  func generateTimestamp() {
    timestampGenerator?.generateTimestamp()
  }

  private func updateObserver() {
    observer?.updateTimeStamps(timestamps: timestampGenerator?.timestamps ?? [])
  }
}

// MARK: - TimestampGeneratorObserver
extension TimestampListUseCase: TimestampGeneratorObserver {

  func timestampGeneratorDidUpdate() {
    updateObserver()
  }
}
