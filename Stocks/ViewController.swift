//
//  ViewController.swift
//  Stocks
//
//  Created by Афанасьев Александр Иванович on 03.09.2021.
//

import UIKit
import SystemConfiguration

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var lightDesign = true
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(self.companies.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.activityIndicator.startAnimating()
        
        let selectedSymbol = Array(self.companies.values)[row]
        self.requestQuote(for: selectedSymbol)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.companies.count
    }
    
    private func requestQuote(for symbol: String) {
        let url = URL(string: "https://query2.finance.yahoo.com/v10/finance/quoteSummary/\(symbol)?modules=price")!
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                let alertController = UIAlertController(title: "Network error", message: "No internet connection", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                print("Network error")
                return
            }

            self.parseQuote(data: data)

        }; dataTask.resume()
    }
    
    
    private func parseQuote(data: Data) {
        let jsonObject = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        let dictQuoteSummary = jsonObject["quoteSummary"] as! [String: Any]
        let info = QuoteSummary(dict: dictQuoteSummary)
        let companyName = info.result.price.longName
        let symbol = info.result.price.symbol
        let price = info.result.price.regularMarketPrice.fmt
        let currencySymbol = info.result.price.currencySymbol
        let priceChange = info.result.price.regularMarketChange.raw
        
        DispatchQueue.main.async {
            self.displayStockInfo(companyName: companyName, symbol: symbol, price: price, currencySymbol: currencySymbol, priceChange: priceChange)
        }
    }
    
    private func displayStockInfo(companyName: String, symbol: String, price: String, currencySymbol: String, priceChange: Double) {
        self.activityIndicator.stopAnimating()
        self.companyName.text = companyName
        self.companySymbol.text = symbol
        self.price.text = price + " " + currencySymbol
        if priceChange > 0 {
            self.priceChange.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        else if priceChange < 0 {
            self.priceChange.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
        self.priceChange.text = "\(priceChange) " + currencySymbol
        companyIcon.downloaded(from: "https://storage.googleapis.com/iex/api/logos/\(symbol).png")
    }

    
    private func requestQuoteUpdate() {
        self.activityIndicator.startAnimating()
        self.companyName.text = "-"
        self.companySymbol.text = "-"
        self.price.text = "-"
        self.priceChange.text = "-"
        self.priceChange.textColor = .black
        
        let selectedRow = self.companyPicker.selectedRow(inComponent: 0)
        let selectedSymbol = Array(self.companies.values)[selectedRow]
        self.requestQuote(for: selectedSymbol)
    }
    
    private func ifConnected() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
         } else {
            let alertController = UIAlertController(title: "Network error", message: "No internet connection", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    
    

    @IBOutlet weak var companyNameDes: UILabel!
    @IBOutlet weak var symbolDes: UILabel!
    @IBOutlet weak var priceDes: UILabel!
    @IBOutlet weak var priceChangeDes: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companySymbol: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var priceChange: UILabel!
    
    @IBAction func themeSwitcher(_ sender: Any) {
        if self.lightDesign {
            self.lightDesign = false
            self.themeLabel.text = "Dark design"
            self.themeLabel.textColor = .white
            self.view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            self.companyName.textColor = .white
            self.companySymbol.textColor = .white
            self.price.textColor = .white
            self.activityIndicator.color = .white
            self.companyNameDes.textColor = .white
            self.symbolDes.textColor = .white
            self.priceDes.textColor = .white
            self.priceChangeDes.textColor = .white
            self.appLabel.backgroundColor = .none
            self.companyPicker.setValue(UIColor.white, forKey: "textColor")
        }
        else {
            self.lightDesign = true
            self.themeLabel.text = "Light design"
            self.themeLabel.textColor = .black
            self.view.backgroundColor = .systemBackground
            self.companyName.textColor = .black
            self.companySymbol.textColor = .black
            self.price.textColor = .black
            self.activityIndicator.color = .black
            self.companyNameDes.textColor = .black
            self.symbolDes.textColor = .black
            self.priceDes.textColor = .black
            self.priceChangeDes.textColor = .black
            self.appLabel.backgroundColor = .none
            self.companyPicker.setValue(UIColor.black, forKey: "textColor")
        }
    }
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var appLabel: UINavigationBar!
    
    @IBOutlet weak var companyPicker: UIPickerView!
    
    @IBOutlet weak var companyIcon: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let companies = ["Apple": "AAPL",
                             "Microsoft": "MSFT",
                             "Google": "GOOG",
                             "Amazon": "AMZN",
                             "Facebook": "FB"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companyPicker.dataSource = self
        self.companyPicker.delegate = self
        
        self.activityIndicator.hidesWhenStopped = true
        
        self.requestQuoteUpdate()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ifConnected()
    }


}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    
}
