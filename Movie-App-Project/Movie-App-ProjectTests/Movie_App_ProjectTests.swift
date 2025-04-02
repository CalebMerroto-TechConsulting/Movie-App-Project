//
//  Movie_App_ProjectTests.swift
//  Movie-App-ProjectTests
//
//  Created by Caleb Merroto on 3/26/25.
//

import FirebaseAuth
import XCTest
@testable import Movie_App_Project

final class Movie_App_ProjectTests: XCTestCase {

    class InvalidDataRepo: RepoProtocol {
        func fetch<T: Decodable>(url: String) async throws -> T {
            // This is intentionally invalid JSON.
            let invalidData = "invalid data".data(using: .utf8)!
            return try JSONDecoder().decode(T.self, from: invalidData)
        }
    }
    
    class MockImageRepo: ImageRepoProtocol {
        var imageToReturn: UIImage?
        var errorToThrow: Error?
        
        func fetchImage(url: String) async throws -> UIImage? {
            if let error = errorToThrow {
                throw error
            }
            return imageToReturn
        }
    }

    
    override func setUpWithError() throws {
        Repo.shared.setNetwork(api: mockNet())
    }

    override func tearDownWithError() throws {
    }

    func testFetchInvalidData() async {
        // Instantiate a ViewModel for Movie with our InvalidDataRepo.
        let vm = ViewModel<Movie>(repository: InvalidDataRepo())
        await vm.fetch("https://example.com/invalid")
        
        // Check that data is nil and an error is set.
        XCTAssertNil(vm.data, "Expected data to be nil when invalid JSON is returned.")
        XCTAssertNotNil(vm.error, "Expected an error when decoding invalid JSON.")
    }

    func testMovieListFetching() async throws {
        let vm = ViewModel<MovieNames>()
        await vm.fetch(tasteDiveURL("Avengers"))
        
        XCTAssertNotNil(vm.data, "Movie names data should not be nil")
        XCTAssertGreaterThan(vm.data?.movies.count ?? 0, 0, "Movie list should contain at least one movie")
    }
    
    func testMovieDataFetching() async throws {
        let vm = ViewModel<Movie>()
        await vm.fetch(OMDBURL("The Avengers"))
        
        XCTAssertNotNil(vm.data, "Movie names data should not be nil")
        XCTAssertEqual(vm.data?.Title, "The Avengers", "Movie Title is incorrect")
        XCTAssertEqual(vm.data?.Year, "2012", "Movie Year is incorrect")
        
        XCTAssertNil(vm.error)
    }
    
    func testMovieListCombination() {
        let movies = MovieNames(similar: MovieNames.searchResult(info:
                            [
                                Item(name: "Iron Man"),
                                Item(name: "Iron Man"),
                                Item(name: "Iron Man 2")
                            ], results: [
                                Item(name: "The Avengers"),
                                Item(name: "Spider Man"),
                                Item(name: "Thor")
                            ]))
        XCTAssertEqual(movies.movies, [Item(name: "Iron Man"),
                                       Item(name: "Iron Man 2"),
                                       Item(name: "The Avengers"),
                                       Item(name: "Spider Man"),
                                       Item(name: "Thor")])
    }
    
    func testRatingSourceFraction() {
        let rating = RatingSource(Source: "Internet Movie Database", Value: "7.0/10")
        // Expected: 7.0 is rounded to 7.
        XCTAssertEqual(rating.value, 7, "Expected '7.0/10' to produce a rating of 7")
    }
    
    func testRatingSourcePercent() {
        let rating = RatingSource(Source: "Rotten Tomatoes", Value: "77%")
        // Expected: 77% becomes 77 / 10 = 7.7, rounded to 8.
        XCTAssertEqual(rating.value, 8, "Expected '77%' to produce a rating of 8")
    }
    
    func testRatingSourceInvalid() {
        let rating = RatingSource(Source: "Metacritic", Value: "N/A")
        // Expected: An unrecognized format should yield 0.
        XCTAssertEqual(rating.value, 0, "Expected an invalid rating string to produce a rating of 0")
    }
    
    func testMovieDecoding() throws {
            let jsonString = """
            {
                "Title": "Test Movie",
                "Year": "2022",
                "Rated": "PG",
                "Released": "01 Jan 2022",
                "Runtime": "120 min",
                "Genre": "Action",
                "Director": "Test Director",
                "Writer": "Test Writer",
                "Actors": "Actor A, Actor B",
                "Plot": "Test plot.",
                "Language": "English",
                "Country": "USA",
                "Awards": "None",
                "Poster": "http://example.com/poster.jpg",
                "Ratings": [
                    { "Source": "Internet Movie Database", "Value": "7.0/10" },
                    { "Source": "Rotten Tomatoes", "Value": "77%" }
                ],
                "BoxOffice": "$100,000,000"
            }
            """
            let data = jsonString.data(using: .utf8)!
            let decoder = JSONDecoder()
            let movie = try decoder.decode(Movie.self, from: data)
            
            XCTAssertEqual(movie.Title, "Test Movie")
            XCTAssertEqual(movie.Year, "2022")
            XCTAssertEqual(movie.Rated, "PG")
            XCTAssertEqual(movie.Ratings.count, 2, "Expected two ratings")
            // The two ratings should be 7 and 8; the average (7+8)/2 is 7.5 which becomes 7 when using integer division.
            XCTAssertEqual(movie.starRating, 7, "Expected starRating to be 7")
        }
        
    func testMovieStarRatingNoRatings() {
        let movie = Movie(
            Title: "No Rating Movie",
            Year: "2022",
            Rated: "PG",
            Released: "01 Jan 2022",
            Runtime: "100 min",
            Genre: "Drama",
            Director: "Test Director",
            Writer: "Test Writer",
            Actors: "Actor A, Actor B",
            Plot: "No ratings available.",
            Language: "English",
            Country: "USA",
            Awards: "None",
            Poster: "http://example.com/poster.jpg",
            Ratings: [],
            BoxOffice: nil
        )
        XCTAssertEqual(movie.starRating, 0, "Expected starRating to be 0 when there are no ratings")
    }
    
    func testRepoCaching() async throws {
        struct Dummy: Decodable, Equatable {
            let value: Int
        }
        
        class DummyNet: NetworkService {
            func get(url: String) async throws -> Data? {
                return "{\"value\": 42}".data(using: .utf8)
            }
        }
        
        class CountingMockNet: NetworkService {
            var count = 0
            let underlying: NetworkService
            init(underlying: NetworkService) {
                self.underlying = underlying
            }
            func get(url: String) async throws -> Data? {
                count += 1
                return try await underlying.get(url: url)
            }
        }
        
        let testURL = "https://example.com/dummyTest_\(UUID().uuidString)"
        let countingNet = CountingMockNet(underlying: DummyNet())
        
        Repo.shared.setNetwork(api: countingNet)
        
        let dummy1: Dummy = try await Repo.shared.fetch(url: testURL)
        XCTAssertEqual(dummy1, Dummy(value: 42))
        
        let dummy2: Dummy = try await Repo.shared.fetch(url: testURL)
        XCTAssertEqual(dummy2, Dummy(value: 42))
        
        XCTAssertEqual(countingNet.count, 1, "Expected network call to be made only once due to caching")
    }
    
    func testImageVMFetchSuccess() async {
        // Create a simple 1x1 pixel image (blue).
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIColor.blue.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let testImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let mockRepo = MockImageRepo()
        mockRepo.imageToReturn = testImage
        let imageVM = ImageVM(repository: mockRepo)
        
        await imageVM.fetch("https://example.com/testImage")
        
        XCTAssertNotNil(imageVM.data, "ImageVM should have image data after a successful fetch")
        let fetchedData = imageVM.data?.pngData()
        let testData = testImage.pngData()
        XCTAssertEqual(fetchedData, testData, "The fetched image should match the test image")
        XCTAssertNil(imageVM.error, "ImageVM should not have an error on a successful fetch")
    }

    func testImageVMFetchFailure() async {
        let mockRepo = MockImageRepo()
        mockRepo.errorToThrow = APIError.requestError(message: "Test error")
        let imageVM = ImageVM(repository: mockRepo)
        
        await imageVM.fetch("https://example.com/testImage")
        
        XCTAssertNil(imageVM.data, "ImageVM's data should be nil on a failed fetch")
        XCTAssertNotNil(imageVM.error, "ImageVM should have an error when the fetch fails")
    }
    
    func testImageRepoSaveAndFetchProfileImage() throws {
        let testEmail = "test@example.com"
        
        // Create a simple 1x1 pixel image (red).
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIColor.red.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let testImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        try ImageRepo.shared.saveProfileImage(for: testEmail, image: testImage)
        
        let fetchedImage = ImageRepo.shared.fetchProfileImage(for: testEmail)
        
        XCTAssertNotNil(fetchedImage, "Fetched image should not be nil after saving")
        
        let originalData = testImage.pngData()
        let fetchedData = fetchedImage?.pngData()
        XCTAssertEqual(originalData, fetchedData, "Fetched image should match the saved image")
    }
    
    func testLoadProfile() {
            ProfileManager.shared.unloadProfile()
            
            let expectation = XCTestExpectation(description: "Load profile")
            
            ProfileManager.shared.loadProfile {
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 2.0)
            
            XCTAssertEqual(ProfileManager.shared.email, "test@example.com")
            XCTAssertEqual(ProfileManager.shared.username, "TestUser")
            XCTAssertEqual(ProfileManager.shared.favorites, ["Movie1", "Movie2"])
            let defaultImageData = UIImage(systemName: "person.circle")!.pngData()
            XCTAssertEqual(ProfileManager.shared.profileImage.pngData(), defaultImageData)
        }
        
        func testAddAndRemoveFavorite() {
            ProfileManager.shared.unloadProfile()
            
            // Initially, favorites should be empty.
            XCTAssertTrue(ProfileManager.shared.favorites.isEmpty)
            
            // Add a favorite.
            ProfileManager.shared.addFavorite("New Movie")
            XCTAssertTrue(ProfileManager.shared.favorites.contains("New Movie"))
            
            ProfileManager.shared.addFavorite("New Movie")
            let count = ProfileManager.shared.favorites.filter { $0 == "New Movie" }.count
            XCTAssertEqual(count, 1)
            
            // Remove the favorite.
            ProfileManager.shared.removeFavorite("New Movie")
            XCTAssertFalse(ProfileManager.shared.favorites.contains("New Movie"))
        }
        
        func testSetProfileImage() throws {
            // Create a simple test image.
            UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
            UIColor.green.setFill()
            UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let testImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            // Call setProfileImage.
            ProfileManager.shared.setProfileImage(testImage)
            
            // Give a short delay for the main-thread update.
            let expectation = XCTestExpectation(description: "Set profile image")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1.0)
            
            // Verify that the profile image has been updated.
            XCTAssertEqual(ProfileManager.shared.profileImage.pngData(), testImage.pngData())
        }
    
    
}
