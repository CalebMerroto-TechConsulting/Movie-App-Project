//
//  VMProtocol.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//


import SwiftUI

protocol VMProtocol: ObservableObject {
    associatedtype DataType
    var data: DataType? { get }
    var error: APIError? { get set }
    func fetch(_ url: String) async
}
