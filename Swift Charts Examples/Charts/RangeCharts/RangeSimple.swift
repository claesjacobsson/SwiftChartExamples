//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct RangeSimple: View {
	var isOverview: Bool

    @State private var barWidth = 10.0
    @State private var chartColor: Color = .blue
    @State private var isShowingPoints = false
    
    var body: some View {
		if isOverview {
			chart
		} else {
			List {
				Section {
					chart
				}

				customisation
			}
			.navigationBarTitle(ChartType.rangeSimple.title, displayMode: .inline)
		}
    }

	private var chart: some View {
		Chart(SalesData.last12Months, id: \.month) {
			BarMark(
				x: .value("Month", $0.month, unit: .month),
				yStart: .value("Sales Min", $0.dailyMin),
				yEnd: .value("Sales Max", $0.dailyMax),
                width: .fixed(isOverview ? 10 : barWidth)
			)
			.clipShape(Capsule())
			.foregroundStyle(chartColor.gradient)

			if isShowingPoints {
				PointMark(
					x: .value("Month", $0.month, unit: .month),
					y: .value("Sales Min", $0.dailyMin)
				)
				.offset(y: -(barWidth / 2))
				.foregroundStyle(.yellow.gradient)
				.symbolSize(CGSize(width: barWidth * 2/3, height: barWidth * 2/3))

				PointMark(
					x: .value("Month", $0.month, unit: .month),
					y: .value("Sales Max", $0.dailyMax)
				)
				.offset(y: barWidth / 2)
				.foregroundStyle(.yellow.gradient)
				.symbolSize(CGSize(width: barWidth * 2/3, height: barWidth * 2/3))
			}
		}
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
	}

    private var customisation: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Bar Width: \(barWidth, specifier: "%.1f")")
                Slider(value: $barWidth, in: 5...20) {
                    Text("Bar Width")
                } minimumValueLabel: {
                    Text("5")
                } maximumValueLabel: {
                    Text("20")
                }
            }
            
            ColorPicker("Color Picker", selection: $chartColor)
            Toggle("Show Min & Max Points", isOn: $isShowingPoints.animation())
        }
    }
}

struct RangeSimple_Previews: PreviewProvider {
    static var previews: some View {
        RangeSimple(isOverview: true)
		RangeSimple(isOverview: false)
    }
}
