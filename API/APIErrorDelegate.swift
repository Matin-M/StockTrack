//
//  APIErrorDelegate.swift
//  StockTrack
//
//  Created by Matin Massoudi on 1/1/21.
//

protocol APIErrorDelegate{
    func clientError() -> Void
    func serverError() -> Void
}
