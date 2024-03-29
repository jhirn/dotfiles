#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title airpod toggle
// @raycast.mode silent
// @raycast.packageName Audio
//
// Optional parameters:
// @raycast.icon images/airpod.png
//
// Documentation:
// @raycast.description Toggle AirPods bluetooth device
// @raycast.author Nichlas W. Andersen
// @raycast.authorURL https://github.com/itsnwa

import IOBluetooth

// Get your device's MAC address by option (⌥) + clicking the bluetooth icon in the menu bar
let deviceAddress = "90-9C-4A-E6-A3-B9"

func toggleAirPods() {
    guard let bluetoothDevice = IOBluetoothDevice(addressString: deviceAddress) else {
        print("Device not found")
        exit(1)
    }

    if !bluetoothDevice.isPaired() {
        print("Device not paired")
        exit(1)
    }

    if bluetoothDevice.isConnected() {
        print("AirPods would have disconnected, if this script worked....")
        bluetoothDevice.closeConnection()
    } else {
        print("AirPods Connected")
        bluetoothDevice.openConnection()
    }
}

toggleAirPods()
