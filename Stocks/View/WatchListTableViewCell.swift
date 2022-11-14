//
//  WatchListTableViewCell.swift
//  Stocks
//
//  Created by Khaleel Musleh on 10/8/22.
//

import UIKit

protocol WatchListTableViewCellDelegate: AnyObject {
    func didUpdateMaxWidth()
}

class WatchListTableViewCell: UITableViewCell {
    static let identifier = "WatchListTableViewCell"
    
    weak var delegate: WatchListTableViewCellDelegate?

    static let preferredHeight: CGFloat = 60
    
    struct ViewModel {
        let symbol: String
        let companyName: String
        let price: String // Should be Formatted
        let changeColor: UIColor // red or green
        let changePercentage: String // Should be Formatted
        let chartViewModel: StockChartView.ViewModel
    }
    
    // Symbol Label
    private let symbolLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    // Company Label
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    // Minichart View
    
    // Price Label
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    // Change in Price Label
    private let changePriceLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        return label
    }()
    
    // MARK: - Private
    private let miniChartView: StockChartView = {
       let chart = StockChartView()
        chart.isUserInteractionEnabled = false
        chart.clipsToBounds = true
        return chart
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubViews(
            symbolLabel,
            nameLabel,
            miniChartView,
            priceLabel,
            changePriceLabel
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        symbolLabel.sizeToFit()
        nameLabel.sizeToFit()
        priceLabel.sizeToFit()
        changePriceLabel.sizeToFit()
        
        let yStart: CGFloat = (contentView.height - symbolLabel.height - nameLabel.height) / 2
        symbolLabel.frame = CGRect(x: separatorInset.left,
                                   y: yStart,
                                   width: symbolLabel.width,
                                   height: symbolLabel.height)
        
        nameLabel.frame = CGRect(x: separatorInset.left,
                                 y: symbolLabel.bottom,
                                   width: nameLabel.width,
                                   height: nameLabel.height)
        
        let currentWidth = max(max(
            priceLabel.width, changePriceLabel.width),
            WatchListViewController.maxChangeWidth
        )
        
        if currentWidth > WatchListViewController.maxChangeWidth {
            WatchListViewController.maxChangeWidth = currentWidth
            delegate?.didUpdateMaxWidth()
        }
        
        priceLabel.frame = CGRect(x: contentView.width - 10 - currentWidth,
                                  y: (contentView.height - priceLabel.height - changePriceLabel.height)/2,
                                  width: currentWidth,
                                  height: priceLabel.height)
        
        changePriceLabel.frame = CGRect(x: contentView.width - 10 - currentWidth,
                                        y: priceLabel.bottom,
                                  width: currentWidth,
                                  height: changePriceLabel.height)
        
        miniChartView.frame = CGRect(x: priceLabel.left - (contentView.width/3) - 5,
                                     y: 6,
                                     width: contentView.width / 3,
                                     height: contentView.height - 12)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        nameLabel.text = nil
        priceLabel.text = nil
        changePriceLabel.text = nil
        miniChartView.reset()
    }
    
    public func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        nameLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changePriceLabel.text = viewModel.changePercentage
        changePriceLabel.backgroundColor = viewModel.changeColor
        // Configure Chart
        miniChartView.configure(with: viewModel.chartViewModel)
    }
}
