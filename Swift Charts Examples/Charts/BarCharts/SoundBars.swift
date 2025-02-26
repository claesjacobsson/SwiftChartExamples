//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct SoundBars: View {
    var isOverview: Bool

    @ObservedObject private var mic = MicrophoneMonitor()
    @State private var data: [Sample] = Sample.overviewSample

    var body: some View {
        if isOverview {
            chart
        } else {
            List {
                Section {
                    chart
                }
                Section {
                    Text("Make some noise to see the data fluctuate...\nE.g. Speak, click fingers, clap hands")
                        .font(.callout)
                }
            }
            .navigationBarTitle(ChartType.soundBar.title, displayMode: .inline)
            .onAppear {
                mic.onUpdate = {
                    withAnimation {
                        data.append(Sample(sample: mic.sample))
                        if data.count > 30 {
                            data.removeFirst()
                        }
                    }
                }
            }
        }
    }

    private var chart: some View {
        Chart(data, id: \.self) { sample in
            let index = data.firstIndex(of: sample) ?? 0
            BarMark(
                x: .value("Index", index),
                y: .value("Value", sample.sample),
                stacking: .center
            )
        }
        .chartYScale(domain: -1...1)
        .chartXAxis(isOverview ? .hidden : .automatic)
        .chartYAxis(isOverview ? .hidden : .automatic)
        .chartLegend(isOverview ? .hidden : .automatic)
        .frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
    }

    struct Sample: Identifiable, Hashable {
        let id = UUID()
        let sample: Float

        static let overviewSample: [Sample] = {
            [0.35948253, 0.30943906, 1.8279682, 1.4172969, 1.0933701, 0.82585114, 0.65808016, 0.5297032, 0.4252133, 0.35630605, 0.33213347, 0.30106705, 0.25619543, 0.29941928, 0.29297554, 0.30697352, 0.2800905, 1.272397, 1.0106244, 0.7855328, 0.62092084, 0.48508847, 0.41100854, 0.4160625, 0.40260378, 0.36971658, 0.31220895, 0.2956296, 0.8334926, 0.6564857].map {
                Sample(sample: $0)
            }
        }()
    }
}

struct SoundBars_Previews: PreviewProvider {
    static var previews: some View {
        SoundBars(isOverview: true)
        SoundBars(isOverview: false)
    }
}
