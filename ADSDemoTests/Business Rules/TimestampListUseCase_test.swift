@testable import ADSDemo
import XCTest

class TimestampGenerator_spy: TimestampGenerator {
  override var timestamps: [Date] { _timestamps }
  var _timestamps = [Date]()

  var addObserver_args = [TimestampGeneratorObserver]()
  override func addObserver(_ observer: TimestampGeneratorObserver) {
    addObserver_args.append(observer)
  }

  var generateTimestamp_callCount = 0
  override func generateTimestamp() {
    generateTimestamp_callCount += 1
  }
}

class TimestampListUseCaseObserver_spy: TimestampListUseCaseObserver {

  var updateTimeStamps_args = [[Date]]()
  func updateTimeStamps(timestamps: [Date]) {
    updateTimeStamps_args.append(timestamps)
  }
}

class TimestampListUseCase_test: XCTestCase {
  var sutReference: Any?

  override func tearDown() {
    sutReference = nil
  }

  func makeSut() -> (TimestampListUseCase,
                     TimestampGenerator_spy,
                     TimestampListUseCaseObserver_spy)
  {
    let timestampGenerator_spy = TimestampGenerator_spy()
    let useCaseObserver_spy = TimestampListUseCaseObserver_spy()
    let sut = TimestampListUseCase(timestampGenerator: timestampGenerator_spy)
    sut.observer = useCaseObserver_spy
    return (sut, timestampGenerator_spy, useCaseObserver_spy)
  }
}

// MARK: - Retain Cycles
extension TimestampListUseCase_test {

  func test_givenTimestampGenerator_whenInitAndReleaseLocalStrongReference_thenSutTimestampGeneraltorIsNil() {
    var timestampGenerator: TimestampGenerator_spy? = .init()
    weak var weakTimestampGenerator = timestampGenerator
    sutReference = TimestampListUseCase(timestampGenerator: timestampGenerator!)

    timestampGenerator = nil
    XCTAssertNil(weakTimestampGenerator)
  }

  func test_givenObserver_whenSetSutObserverAndReleaseLocalStrongReference_thenSutObserverIsNil() {
    var observer: TimestampListUseCaseObserver_spy? = .init()
    let sut = TimestampListUseCase()
    sut.observer = observer
    XCTAssertNotNil(sut.observer)
    observer = nil
    XCTAssertNil(sut.observer)
  }
}

// MARK: - TimestampGenerator interactions
extension TimestampListUseCase_test {

  func test_givenTimestampGenerator_whenInit_thenAddSelfToTimestampGeneratorObservers() {
    let (sut, timestampGenerator_spy, _) = makeSut()

    XCTAssertEqual(timestampGenerator_spy.addObserver_args.count, 1)
    XCTAssertTrue(timestampGenerator_spy.addObserver_args.last === sut)
  }

  func test_givenInitialState_whenGenerateTimestamp_thenCallGenerateTimestampOnTimestampGenerator() {
    let (sut, timestampGenerator_spy, _) = makeSut()
    XCTAssertEqual(timestampGenerator_spy.generateTimestamp_callCount, 0)

    sut.generateTimestamp()

    XCTAssertEqual(timestampGenerator_spy.generateTimestamp_callCount, 1)
  }
}

// MARK: - Observer interactions
extension TimestampListUseCase_test {

  func test_givenInitialState_whenSetObserver_thenUpdateObserverWithGeneratorTimestamps() {
    let (sut, timestampGenerator_spy, _) = makeSut()
    let timestamps = [Date(), Date()]
    timestampGenerator_spy._timestamps = timestamps
    let useCaseObserver_spy = TimestampListUseCaseObserver_spy()
    XCTAssertEqual(useCaseObserver_spy.updateTimeStamps_args.count, 0)

    sut.observer = useCaseObserver_spy

    XCTAssertEqual(useCaseObserver_spy.updateTimeStamps_args.count, 1)
    XCTAssertEqual(useCaseObserver_spy.updateTimeStamps_args.last, timestamps)
  }

  func test_givenInitialState_whenTimestampGeneratorDidUpdate_thenUpdateObserverWithGeneratorTimestamps() {
    let (sut, timestampGenerator_spy, useCaseObserver_spy) = makeSut()
    let timestamps = [Date(), Date()]
    timestampGenerator_spy._timestamps = timestamps

    sut.timestampGeneratorDidUpdate()

    XCTAssertEqual(useCaseObserver_spy.updateTimeStamps_args.last, timestamps)
  }
}
