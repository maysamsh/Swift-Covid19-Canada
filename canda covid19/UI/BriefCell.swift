//
//  BriefCell.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-09.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import UIKit
import Charts

struct CellInfoStrct {
    let title: String
    let subTitle:String
}

enum CellTitlePosition {
    case left
    case right
}

struct BriefCellStruct {
    let leftCell: CellInfoStrct
    let centerCell: CellInfoStrct
    let rightCell: CellInfoStrct
    let bottomRightTitle: String
    let bottomLeftTitle: String
    let bottomLabel: String?
    let deathRate: Double?
    let doublingTime: Int?
    let recovered: CSVDecodable?
    let chartData: [CSVDecodable]
}

@IBDesignable
class BriefCell: UIView {
    private var view: UIView!
    
    @IBOutlet private weak var leftCell: InfoCell!
    @IBOutlet private weak var centerCell: InfoCell!
    @IBOutlet private weak var rightCell: InfoCell!
    @IBOutlet private weak var topLeftLabel: UILabel!
    @IBOutlet private weak var topRightLabel: UILabel!
    @IBOutlet private weak var topWrapper: UIView!
    @IBOutlet private weak var bottomLeftLabel: UILabel!
    @IBOutlet private weak var bottomRightLabel: UILabel!
    @IBOutlet private weak var bottomLabel: UILabel!
    @IBOutlet private weak var chart: CombinedChartView!
    
    private var briefCell: BriefCellStruct?
    private var chartData = [CSVDecodable]()
    private var dragIsEnabled = false
    private var showMarker = false
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutSubviews()
        setup()
    }
    
    private func setup() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        self.view = view
        view.backgroundColor = .clear
        self.backgroundColor = .clear
    }

    private func presetCellTitle(for cell: InfoCell, title: String, subTitle: String){
        cell.titleLabel.text = title
        cell.subtitleLabel.text = subTitle
    }
    
    func setSubValue(field: InfoCell, todayCases: Int, animationDuration: TimeInterval){
        if todayCases == 0 {
            field.subValueLabel.text = ""
        } else {
            field.subValueLabel.countFrom(CGFloat(0), to: CGFloat(todayCases), withDuration: animationDuration)
        }
        
        if todayCases > 0 {
            field.subValuePrefix.text = "+"
        } else if todayCases == 0{
            field.subValuePrefix.text = ""
        } else {
            field.subValuePrefix.text = "-"
        }
    }
    
    func setChartData(data: [CSVDecodable], keyPath: KeyPath<CSVDecodable, Int>){
        var maxLeft: Double = 0
        var maxRight: Double = 0
        
        let valuesCases = data.enumerated().map { (index, item) -> ChartDataEntry in
            maxLeft = item[keyPath: keyPath] > Int(maxLeft) ? Double(item[keyPath: keyPath]) : maxLeft
            return ChartDataEntry(x: Double(index), y: Double(item[keyPath: keyPath]))
        }
        
        let valuesDeaths = data.enumerated().map { (index, item) -> BarChartDataEntry in
            maxRight = item.deaths > Int(maxRight) ? Double(item.deaths) : maxRight
            return BarChartDataEntry(x: Double(index), y: Double(item.deaths))
        }
        
        maxLeft = maxLeft * 1.2
        maxRight = maxRight * 1.2
        self.chartData = data
        configureChartView(maximumLeft: maxLeft, maximumRight: maxRight)
        let set1 = LineChartDataSet(entries: valuesCases, label: "Cases")
        set1.mode = .cubicBezier
        set1.axisDependency = .left
        set1.drawCirclesEnabled = false
        set1.lineWidth = 2
        
        set1.fillAlpha = 1
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.valueFont = UIFont.systemFont(ofSize: 0)
        
        let set2 = BarChartDataSet(entries: valuesDeaths, label: "Deaths")
        
        set2.valueFont = UIFont.systemFont(ofSize: 0)
        set2.axisDependency = .right
        
        if #available(iOS 13.0, *) {
            set1.colors = [.label]
            set2.colors = [.systemRed]
        } else {
            set1.colors = [.black]
            set2.colors = [.red]
        }
        
        if showMarker {
            let marker = XYMarkerView(color: .black,
                                      font: .systemFont(ofSize: 12),
                                      textColor: .white,
                                      insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                      xAxisValueFormatter: chart.xAxis.valueFormatter!)
            marker.chartView = chart
            marker.minimumSize = CGSize(width: 80, height: 40)
            chart.marker = marker
        }
        
        let combinedData = CombinedChartData()
        combinedData.lineData = LineChartData(dataSet: set1)
        combinedData.barData = BarChartData(dataSet: set2)
        
        chart.xAxis.axisMaximum = combinedData.xMax + 0.25
        chart.data = combinedData
    }
    
    func configureTotalCellWithCompare(field: InfoCell, today: CSVDecodable, yesterday: CSVDecodable,
                                       type: KeyPath<CSVDecodable, Int>, animationDuration: TimeInterval) {
        
        field.valueLabel.text = "\(today[keyPath: type].formattedWithSeparator)"
        self.setSubValue(field: field, todayCases: today[keyPath: type] - yesterday[keyPath: type],
                         animationDuration: animationDuration)
    }
    
    func configureTotalCellWithCompare(field: InfoCell, province: Province, today: CSVDecodable, yesterday: CSVDecodable, type: KeyPath<CSVDecodable, String?>, animationDuration: TimeInterval) {
                
        let _today = today[keyPath: type]
        let _yesterday = yesterday[keyPath: type]
        
        switch (_today, _yesterday) {
        case (.some(let t), .some(let y)):
            let __today = Int(t) ?? 0
            let __yesterday = Int(y) ?? 0
            field.valueLabel.text = "\(__today.formattedWithSeparator)"
            self.setSubValue(field: field, todayCases: __today - __yesterday,
                             animationDuration: animationDuration)
        case (.some(let t), nil):
            let __today = Int(t) ?? 0
            field.valueLabel.text = "\(__today.formattedWithSeparator)"
            field.subValueLabel.text = "(Today)"
        case (nil, .some(let y)):
            let __yesterday = Int(y) ?? 0
            field.valueLabel.text = "\(__yesterday.formattedWithSeparator)"
            field.subValueLabel.text = "(Yesterday)"
        case (nil, nil):
            if let recovered = briefCell?.recovered {
                field.valueLabel.text = recovered.recovered ?? "Not available"
                field.subValueLabel.text = "(\(StringFormatter.getDayMonth(from: recovered.date)))"
            } else {
                field.valueLabel.text = "Not available"
                field.subValueLabel.text = "Try later"
            }
        }
    }
        
    private func configureChartView(maximumLeft: Double, maximumRight: Double) {
        chart.delegate = self
        chart.drawOrder = [2, 0]
        chart.chartDescription?.enabled = false
        chart.dragEnabled = self.dragIsEnabled
        chart.setScaleEnabled(true)
        chart.pinchZoomEnabled = true
        
        let leftAxis = chart.leftAxis
        leftAxis.axisMaximum = maximumLeft
        leftAxis.axisMinimum = 0
        
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        //leftAxis.gridLineDashLengths = [5, 5]
        
        let rightAxis = chart.rightAxis
        rightAxis.axisMaximum = maximumRight
        rightAxis.axisMinimum = 0
        rightAxis.granularityEnabled = true
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = false
        
        if #available(iOS 13.0, *) {
            leftAxis.labelTextColor = .label
            rightAxis.labelTextColor = .label
            chart.legend.textColor = .label
            chart.xAxis.labelTextColor = .label
        }
        
        leftAxis.drawLimitLinesBehindDataEnabled = true
        let xFormater = ChartXAxisFormatter(with: chartData)
        chart.xAxis.valueFormatter = xFormater
        
        chart.legend.form = .square
        chart.animate(xAxisDuration: 1)
        
        chart.legend.verticalAlignment = .bottom
        chart.xAxis.labelPosition = .bottom
        
    }
    
    // MARK: - Public API
    
    func setup(data: [CSVDecodable], cellData: BriefCellStruct, showMinimal: Bool = true) {
        if showMinimal == false {
            self.dragIsEnabled = true
            self.showMarker = true
        }
        self.chartData = data
        self.briefCell = cellData
        
        setChartData(data: data, keyPath: \.confirmed)
        presetCellTitle(for: leftCell, title: cellData.leftCell.title, subTitle: cellData.leftCell.subTitle)
        presetCellTitle(for: centerCell, title: cellData.centerCell.title, subTitle: cellData.centerCell.subTitle)
        presetCellTitle(for: rightCell, title: cellData.rightCell.title, subTitle: cellData.rightCell.subTitle)
        
        if let _deathrate = cellData.deathRate {
            let _rate = String(format: "%.2f", _deathrate * 100.0)
            bottomLeftLabel.text = "Death rate: \(_rate)%"
        } else {
            bottomLeftLabel.text = cellData.bottomLeftTitle
        }
        
        if let _doublingTime = cellData.doublingTime {
            bottomRightLabel.text = "Doubling time: \(_doublingTime) days"
        } else {
            bottomRightLabel.text = cellData.bottomRightTitle
        }
        
        
        if let _lastTwoDays = data.getLastTwo() {
            let _today = _lastTwoDays[1]
            let _yesterday = _lastTwoDays[0]
            let _animationDuration = 0.4
            
            self.configureTotalCellWithCompare(field: self.leftCell, today: _today, yesterday: _yesterday,
                                               type: \.confirmed, animationDuration: _animationDuration)
            self.configureTotalCellWithCompare(field: self.centerCell, today: _today, yesterday: _yesterday,
                                               type: \.deaths, animationDuration: _animationDuration)
            self.configureTotalCellWithCompare(field: self.rightCell, province: .Canada, today: _today, yesterday: _yesterday,
                                               type: \.recovered, animationDuration: _animationDuration)
            self.rightCell.alternateColor = true
            self.leftCell.alternateColor = true
            self.centerCell.alternateColor = true
            
            self.rightCell.largerIsWorse = false
            self.leftCell.largerIsWorse = true
            self.centerCell.largerIsWorse = true
        }
        
        bottomLabel.text = cellData.bottomLabel
    }
    
    func setTitle(title: String, for position: CellTitlePosition){
        switch position {
        case .left:
            self.topLeftLabel.text = title
        case .right:
            self.topRightLabel.text = title
        }
    }
    
}

extension BriefCell: ChartViewDelegate {}
