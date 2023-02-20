//
//  P2PKView.swift
//  ErgoStats
//
//  Created by Alin Chitas on 09.02.2023.
//

import SwiftUI
import Charts

struct P2PKView: View {
    @EnvironmentObject var vmAddr: AddressesViewModel
    @EnvironmentObject var vm: MetricsViewModel
    
    @State private var showAlert = false
    
    @State private var lineWidth = 2.0
    @State private var chartColor: Color = .orange
    @State var selectedElement: AddressesItem?
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private var spacing: CGFloat = 30
    private var minBalance: Double = 0.0001
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack {
                    Text("Unique P2PK addresses with minimum balance 1ERG / 30 days")
                        .font(.callout)
                        .foregroundColor(.secondary)
                
                Chart(vmAddr.addresses) {
                    LineMark(
                        x: .value("Date", $0.date),
                        y: .value("Address", $0.ge1)
                    )
                    .accessibilityLabel($0.date.formatted(date: .abbreviated, time: .omitted))
                    .accessibilityValue("\($0.ge1)")
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
                                    Text("\(selectedElement.ge1, format: .number)")
                                        .font(.title2.bold())
                                        .foregroundColor(.primary)
                                }
                                .accessibilityElement(children: .combine)
                                .frame(width: boxWidth, alignment: .leading)
                            }
                        }
                    }
                }
                .frame(height: 250)
                .padding(15)
                
                
                LazyVGrid(
                    columns: columns,
                    alignment: .leading,
                    spacing: spacing,
                    pinnedViews: [],
                    content: {
                        Text("Min.bal.").bold()
                        Text("Current").bold()
                        Text("1 Day").bold()
                        Text("4 Weeks").bold()
                        Text("1 Year").bold()
                        ForEach(vm.summaryP2pk) { sum in
                            Text("\(sum.label.formatAddrRanges().capitalized)").foregroundColor(.orange)
                            Text("\(sum.current)")
                            Text("\(sum.diff1D)")
                            Text("\(sum.diff4W)")
                            Text("\(sum.diff1Y)")
                        }
                    })
            }
            .padding(.leading, 4)
        }
        .onReceive(vmAddr.$error, perform: { error in
            if error != nil {
                showAlert.toggle()
            }
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(vmAddr.error?.localizedDescription ?? ""))
        }
        
    }
    func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> AddressesItem? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for salesDataIndex in vmAddr.addresses.indices {
                let nthSalesDataDistance = vmAddr.addresses[salesDataIndex].date.distance(to: date)
                if abs(nthSalesDataDistance) < minDistance {
                    minDistance = abs(nthSalesDataDistance)
                    index = salesDataIndex
                }
            }
            if let index {
                return vmAddr.addresses[index]
            }
        }
        return nil
    }
}


struct P2PKView_Previews: PreviewProvider {
    static var previews: some View {
        P2PKView()
    }
}
