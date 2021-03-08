import Foundation

protocol TimestampGeneratorObserver: AnyObject {
  func timestampGeneratorDidUpdate()
}

class TimestampGenerator {
  static var shared = TimestampGenerator()

  var timestamps: [Date] { _timestamps }

  private var _timestamps = [Date]() { didSet { notifyObservers() } }

  private var observers = [() -> TimestampGeneratorObserver?]() {
    didSet { observers = observers.filter { $0() != nil } }
  }

  init() {}

  func addObserver(_ observer: TimestampGeneratorObserver) {
    observers.append({ [weak observer] in observer })
  }

  func generateTimestamp() {
    _timestamps.append(Date())
  }

  private func notifyObservers() {
    observers.forEach {
      $0()?.timestampGeneratorDidUpdate()
    }
  }
}

