//
//  Parser.swift
//  Stocks
//
//  Created by Афанасьев Александр Иванович on 04.09.2021.
//

import Foundation

struct emptyStruct {
    
}

struct RawFmt {
    var raw: Double
    var fmt: String
    
    init(dict: [String: Any]) {
        raw = dict["raw"] as? Double ?? 0
        fmt = dict["fmt"] as? String ?? ""
    }
}

struct RawFmtLongFmt {
    var raw: Double
    var fmt: String
    var longFmt: String
    
    init(dict: [String: Any]) {
        raw = dict["raw"] as? Double ?? 0
        fmt = dict["fmt"] as? String ?? ""
        longFmt = dict["longFmt"] as? String ?? ""
    }
}

struct Price {
    var maxAge: Int
    var preMarketChange: emptyStruct
    var preMarketPrice: emptyStruct
    var preMarketSource: String
    var postMarketChangePercent: RawFmt
    var postMarketChange: RawFmt
    var postMarketTime: Int
    var postMarketPrice: RawFmt
    var postMarketSource: String
    var regularMarketChangePercent: RawFmt
    var regularMarketChange: RawFmt
    var regularMarketTime: Int
    var priceHint: RawFmtLongFmt
    var regularMarketPrice: RawFmt
    var regularMarketDayHigh: RawFmt
    var regularMarketDayLow: RawFmt
    var regularMarketVolume: RawFmtLongFmt
    var averageDailyVolume10Day: emptyStruct
    var averageDailyVolume3Month: emptyStruct
    var regularMarketPreviousClose: RawFmt
    var regularMarketSource: String
    var regularMarketOpen: RawFmt
    var strikePrice: emptyStruct
    var openInterest: emptyStruct
    var exchange: String
    var exchangeName: String
    var exchangeDataDelayedBy: Int
    var marketState: String
    var quoteType: String
    var symbol: String
    var underlyingSymbol: String?
    var shortName: String
    var longName: String
    var currency: String
    var quoteSourceName: String
    var currencySymbol: String
    var fromCurrency: String?
    var toCurrency: String?
    var lastMarket: String?
    var volume24Hr: emptyStruct
    var volumeAllCurrencies: emptyStruct
    var circulatingSupply: emptyStruct
    var marketCap: RawFmtLongFmt
    
    init(dict: [String: Any]) {
        maxAge = dict["maxAge"] as? Int ?? 0
        preMarketChange = emptyStruct()
        preMarketPrice = emptyStruct()
        preMarketSource = dict["preMarketSource"] as? String ?? "No info"
        postMarketChangePercent = RawFmt(dict: dict["postMarketChangePercent"] as? [String : Any] ?? [:])
        postMarketChange = RawFmt(dict: dict["postMarketChange"] as! [String : Any])
        postMarketTime = dict["postMarketTime"] as? Int ?? 0
        postMarketPrice = RawFmt(dict: dict["postMarketPrice"] as! [String : Any])
        postMarketSource = dict["postMarketSource"] as? String ?? "No info"
        regularMarketChangePercent = RawFmt(dict: dict["regularMarketChangePercent"] as? [String : Any] ?? [:])
        regularMarketChange = RawFmt(dict: dict["regularMarketChange"] as? [String : Any] ?? [:])
        regularMarketTime = dict["regularMarketTime"] as? Int ?? 0
        priceHint = RawFmtLongFmt(dict: dict["priceHint"] as? [String: Any] ?? [:])
        regularMarketPrice = RawFmt(dict: dict["regularMarketPrice"] as? [String : Any] ?? [:])
        regularMarketDayHigh = RawFmt(dict: dict["regularMarketDayHigh"] as? [String : Any] ?? [:])
        regularMarketDayLow = RawFmt(dict: dict["regularMarketDayLow"] as? [String : Any] ?? [:])
        regularMarketVolume = RawFmtLongFmt(dict: dict["regularMarketVolume"] as? [String: Any] ?? [:])
        averageDailyVolume10Day = emptyStruct()
        averageDailyVolume3Month = emptyStruct()
        regularMarketPreviousClose = RawFmt(dict: dict["regularMarketPreviousClose"] as? [String : Any] ?? [:])
        regularMarketSource = dict["regularMarketSource"] as? String ?? "No info"
        regularMarketOpen = RawFmt(dict: dict["regularMarketOpen"] as? [String : Any] ?? [:])
        strikePrice = emptyStruct()
        openInterest = emptyStruct()
        exchange = dict["exchange"] as? String ?? "No info"
        exchangeName = dict["exchangeName"] as? String ?? "No info"
        exchangeDataDelayedBy = dict["exchangeDataDelayedBy"] as? Int ?? 0
        marketState = dict["marketState"] as? String ?? "No info"
        quoteType = dict["quoteType"] as? String ?? "No info"
        symbol = dict["symbol"] as? String ?? "No info"
        underlyingSymbol = dict["underlyingSymbol"] as? String
        shortName = dict["shortName"] as? String ?? "No info"
        longName = dict["longName"] as? String ?? "No info"
        currency = dict["currency"] as? String ?? "No info"
        quoteSourceName = dict["quoteSourceName"] as? String ?? "No info"
        currencySymbol = dict["currencySymbol"] as? String ?? "No info"
        fromCurrency = dict["fromCurrency"] as? String
        toCurrency = dict["toCurrency"] as? String
        lastMarket = dict["lastMarket"] as? String
        volume24Hr = emptyStruct()
        volumeAllCurrencies = emptyStruct()
        circulatingSupply = emptyStruct()
        marketCap = RawFmtLongFmt(dict: dict["marketCap"] as? [String: Any] ?? [:])

    }
}

struct Result {
    var price: Price
    init(dict: [String: Any]) {
        price = Price(dict: dict["price"] as! [String : Any])
    }
}
 
struct QuoteSummary {
    var result:  Result
    var error: String?
    
    init(dict: [String: Any]) {
        error = dict["error"] as? String
        let tmp = dict["result"] as! [Any]
        result = Result(dict: tmp[0] as! [String : Any])
    }
}
