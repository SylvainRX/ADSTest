@testable import ADSDemo
import XCTest

class TimestampGeneratorObserver_spy: TimestampGeneratorObserver {

  var timestampGeneratorDidUpdate_callCount = 0
  func timestampGeneratorDidUpdate() {
    timestampGeneratorDidUpdate_callCount += 1
  }
}

class TimestampGenerator_test: XCTestCase {

  func test_whenGenerateTimeStamp_thenNewTimeStamp() {
    let sut = TimestampGenerator()
    (1 ... 3).forEach { _ in sut.generateTimestamp() }
    XCTAssertEqual(sut.timestamps.count, 3)
  }

  func test_givenObservers_whenGenerateTimeStamp_thenNotifyObservers() {
    let sut = TimestampGenerator()
    let observer_spy1 = TimestampGeneratorObserver_spy()
    let observer_spy2 = TimestampGeneratorObserver_spy()
    sut.addObserver(observer_spy1)
    sut.addObserver(observer_spy2)

    sut.generateTimestamp()

    XCTAssertEqual(observer_spy1.timestampGeneratorDidUpdate_callCount, 1)
    XCTAssertEqual(observer_spy2.timestampGeneratorDidUpdate_callCount, 1)
  }

  func test_observersAreWeaklyReferenced() {
    let sut = TimestampGenerator()
    var observer_spy: TimestampGeneratorObserver_spy? = .init()
    weak var weakObserver_spy = observer_spy

    sut.addObserver(observer_spy!)

    observer_spy = nil
    XCTAssertNil(weakObserver_spy)
  }
}
