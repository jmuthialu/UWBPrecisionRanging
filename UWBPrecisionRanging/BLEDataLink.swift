//
//  BLEDataLink.swift
//  UWBPrecisionRanging
//
//  Created by Jay Muthialu on 1/16/23.
//

import Foundation
import CoreBluetooth
import Combine

struct Constants {
    static let whiteUWBIdentifier = "B730C7A4-FD26-4ACF-5F9A-78C952F2C7CC" // White UWB
    static let serviceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    static let rxCharacteristicUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    static let txCharacteristicUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
}

class BLEDataLink: NSObject {
    
    var centralManager: CBCentralManager?
    var peripheral: CBPeripheral?
    var peripheralName = ""
    
    var rxCharacteristic: CBCharacteristic? // Peripheral receives from central
    var txCharacteristic: CBCharacteristic? // Peripheral transmits to central
    
    var accessoryReadyPublisher = PassthroughSubject<Void, Never>()
    var dataReceivedPublisher = PassthroughSubject<Data, Never>()
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self,
                                          queue: nil,
                                          options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
    
    func writeData(data: Data) {

        guard let peripheral = peripheral,
              let rxCharacteristic = rxCharacteristic else { return }

        let mtu = peripheral.maximumWriteValueLength(for: .withResponse)

        let bytesToCopy: size_t = min(mtu, data.count)

        var rawPacket = [UInt8](repeating: 0, count: bytesToCopy)
        data.copyBytes(to: &rawPacket, count: bytesToCopy)
        let packetData = Data(bytes: &rawPacket, count: bytesToCopy)
        let stringFromData = packetData.map { String(format: "0x%02x, ", $0) }.joined()
        print("Writing \(bytesToCopy) bytes: \(String(describing: stringFromData))")
        peripheral.writeValue(packetData,
                              for: rxCharacteristic,
                              type: .withResponse)
    }
    
}
