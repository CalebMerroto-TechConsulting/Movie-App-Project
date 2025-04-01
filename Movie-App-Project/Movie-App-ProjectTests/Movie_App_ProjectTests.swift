//
//  Movie_App_ProjectTests.swift
//  Movie-App-ProjectTests
//
//  Created by Caleb Merroto on 3/26/25.
//

import XCTest
@testable import Movie_App_Project

final class Movie_App_ProjectTests: XCTestCase {

    override func setUpWithError() throws {
        Repo.shared.setNetwork(api: mockNet())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testMovieListFetching() async throws {
        let vm = ViewModel<MovieNames>()
        await vm.fetch(tasteDiveURL("Avengers"))
        
        XCTAssertNotNil(vm.data, "Movie names data should not be nil")
        XCTAssertGreaterThan(vm.data?.movies.count ?? 0, 0, "Movie list should contain at least one movie")
    }
    
    func testMovieDataFetching() async throws {
        let vm = ViewModel<Movie>()
        await vm.fetch(tasteDiveURL("The Avengers"))
        
        XCTAssertNotNil(vm.data, "Movie names data should not be nil")
        XCTAssertEqual(vm.data?.Title, "The Avengers", "Movie Title is incorrect")
        XCTAssertEqual(vm.data?.Year, "2012", "Movie Year is incorrect")
        
        XCTAssertNil(vm.error)
    }
    
    func testMovieDataFetchingNonexistentMovie() async throws {
        let vm = ViewModel<Movie>()
        await vm.fetch(OMDBURL("Nonexistent Movie"))
        XCTAssertNotNil(vm.error)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
