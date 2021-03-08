@testable import ADSDemo
import XCTest

class TimestampListView_spy: TimestampListView {

  var updateWithModel_args = [TimestampListViewModel]()
  func update(withModel model: TimestampListViewModel) {
    updateWithModel_args.append(model)
  }
}

class TimestampListUseCase_spy: TimestampListUseCase {

  var generateTimestamp_callCount = 0
  override func generateTimestamp() {
    generateTimestamp_callCount += 1
  }
}

class TimestampListPresenter_test: XCTestCase {
  var sutReference: Any?

  override func tearDown() {
    sutReference = nil
  }

  func makeSut() -> (sut: TimestampListPresenter,
                     view_spy: TimestampListView_spy,
                     useCase_spy: TimestampListUseCase_spy) {
    let useCase_spy = TimestampListUseCase_spy()
    let sut = TimestampListPresenter(useCase: useCase_spy)
    let view_spy = TimestampListView_spy()
    sut.view = view_spy
    return (sut, view_spy, useCase_spy)
  }
}

// MARK: - References
extension TimestampListPresenter_test {

  func test_givenView_whenSetSutViewAndReleaseLocalStrongReference_thenSutViewIsNil() {
    var useCase: TimestampListUseCase_spy? = .init()
    weak var weakUseCase = useCase
    sutReference = TimestampListPresenter(useCase: useCase!)
    useCase = nil
    XCTAssertNotNil(weakUseCase)
  }

  func test_givenUseCase_whenInitSutAndReleaseLocalUseCaseStrongReference_thenSutRetainsUseCase() {
    var useCase: TimestampListUseCase_spy? = .init()
    weak var weakUseCase = useCase
    sutReference = TimestampListPresenter(useCase: useCase!)
    useCase = nil
    XCTAssertNotNil(weakUseCase)
  }
}

// MARK: - View interactions
extension TimestampListPresenter_test {

  func test_givenTimestamps_whenUpdateTimeStamps_thenUpdateViewWithViewModel() {
    let (sut, view_spy, _) = makeSut()
    let timestamps = [Date(), Date()]

    sut.updateTimeStamps(timestamps: timestamps)

    let expectation = TimestampListViewModel(timestamps: timestamps.map { $0.description })
    XCTAssertEqual(view_spy.updateWithModel_args.last, expectation)
  }

  func test_givenUpdateWithTimestamps_whenSetView_thenUpdateViewWithViewModel() {
    let sut = makeSut().sut
    let timestamps = [Date(), Date()]
    sut.updateTimeStamps(timestamps: timestamps)
    let view_spy = TimestampListView_spy()

    sut.view = view_spy

    let expectation = TimestampListViewModel(timestamps: timestamps.map { $0.description })
    XCTAssertEqual(view_spy.updateWithModel_args.last, expectation)
  }
}

// MARK: - UseCase interactions
extension TimestampListPresenter_test {

  func test_givenInitialState_whenRequestNewTimestamp_thenUseCaseGenerateTimeStamp() {
    let (sut, _, useCase_spy) = makeSut()
    XCTAssertEqual(useCase_spy.generateTimestamp_callCount, 0)

    sut.requestNewTimestamp()

    XCTAssertEqual(useCase_spy.generateTimestamp_callCount, 1)
  }
}
