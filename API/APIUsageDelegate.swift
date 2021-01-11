//
//  APIUsageDelegate.swift
//  StockTrack
//
//  Created by Matin Massoudi on 1/9/21.
//

protocol APIUsageDelegate{
    func totalRequest() -> Void
    func chartRequest() -> Void
    func detailRequest() -> Void
    func quoteRequeast() -> Void
}
