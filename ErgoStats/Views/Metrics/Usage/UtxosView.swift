//
//  UtxosView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 09.02.2023.
//

import SwiftUI
import Charts

struct UtxosView: View {
    @ObservedObject var vm: UTXOViewModel
        @State private var showAlert = false
        
        @State private var lineWidth = 2.0
        @State private var chartColor: Color = .orange
        @State private var selectedElement: UTXOItem?
        
        var body: some View {
            ScrollView {
                VStack{
                    Text("UTXO boxes in the last 30 days")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .padding()
                    Chart(vm.utxos) {
                        LineMark(
                            x: .value("Date", $0.date),
                            y: .value("UTXOs", $0.utxo)
                        )
                        .accessibilityLabel($0.date.formatted(date: .abbreviated, time: .omitted))
                        .accessibilityValue("\($0.utxo)")
                        .lineStyle(StrokeStyle(lineWidth: lineWidth))
                        .foregroundStyle(chartColor.gradient)
                        .symbol(Circle().strokeBorder(lineWidth: lineWidth))
                    }
                    .chartYScale(domain: .automatic(includesZero: false))
                    .chartOverlay { proxy in
                        GeometryReader { geo in
                            Rectangle().fill(.clear).contentShape(Rectangle())
                                .gesture(
                                    SpatialTapGesture()
                                        .onEnded { value in
                                            let element = findElement(location: value.location, proxy: proxy, geometry: geo)
                                            if selectedElement?.date == element?.date {
                                                // If tapping the same element, clear the selection.
                                                selectedElement = nil
                                            } else {
                                                selectedElement = element
                                            }
                                        }
                                        .exclusively(
                                            before: DragGesture()
                                                .onChanged { value in
                                                    selectedElement = findElement(location: value.location, proxy: proxy, geometry: geo)
                                                }
                                        )
                                )
                        }
                    }
                    .chartBackground { proxy in
                        ZStack(alignment: .topLeading) {
                            GeometryReader { geo in
                                if let selectedElement {
                                    let dateInterval = Calendar.current.dateInterval(of: .day, for: selectedElement.date)!
                                    let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0
                                    
                                    let lineX = startPositionX1 + geo[proxy.plotAreaFrame].origin.x
                                    let lineHeight = geo[proxy.plotAreaFrame].maxY
                                    let boxWidth: CGFloat = 150
                                    
                                    Rectangle()
                                        .fill(.orange)
                                        .frame(width: 2, height: lineHeight)
                                        .position(x: lineX, y: lineHeight / 2)
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(selectedElement.date, format: .dateTime.year().month().day())")
                                            .font(.callout)
                                            .foregroundStyle(.secondary)
                                        Text("\(selectedElement.utxo, format: .number)")
                                            .font(.title2.bold())
                                            .foregroundColor(.primary)
                                    }
                                    .accessibilityElement(children: .combine)
                                    .frame(width: boxWidth, alignment: .leading)
                                }
                            }
                        }
                    }
                    .frame(height: 300)
                    .padding(5)
                    
                }
            }
            .onReceive(vm.$error, perform: { error in
                if error != nil {
                    showAlert.toggle()
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(vm.error?.localizedDescription ?? ""))
            }
        }
        
        func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> UTXOItem? {
            let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
            if let date = proxy.value(atX: relativeXPosition) as Date? {
                // Find the closest date element.
                var minDistance: TimeInterval = .infinity
                var index: Int? = nil
                for salesDataIndex in vm.utxos.indices {
                    let nthSalesDataDistance = vm.utxos[salesDataIndex].date.distance(to: date)
                    if abs(nthSalesDataDistance) < minDistance {
                        minDistance = abs(nthSalesDataDistance)
                        index = salesDataIndex
                    }
                }
                if let index {
                    return vm.utxos[index]
                }
            }
            return nil
        }
    }

struct UtxosView_Previews: PreviewProvider {
    static var previews: some View {
        UtxosView(vm: UTXOViewModel())
    }
}
