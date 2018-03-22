# RapidSOS Emergency Reference Application (ERA)

## Overview

The RapidSOS Emergency Reference Application, or ERA, is an example of an emergency application build on the [RapidSOS Emergency API](https://rapidsos.com/products/#emergencyapi) and the [RapidSOS Emergency Data SDK](/RSOSData).

The purpose of this reference appliation is to demonstrate the steps necessary to interface with each part of the RapidSOS Emergency API.

The Emergency Reference Application is build using the [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#what-is-cocoapods) dependency manager, and requires CocoaPods 1.0 or later to be [installed](https://guides.cocoapods.org/using/getting-started.html#getting-started). The application requires the [AFNetworking](https://github.com/AFNetworking/AFNetworking) Library, **version 3.0** or later, as a dependency.

Building the app requires **Xcode 9.0 or later**, and the deployment target of the app is **iOS 10.0**.

## Getting Started

To build and run the Emergency Reference App:

1. Make sure CocoaPods 1.0 or later is installed.

2. Clone the Emergency Reference App repository:
```sh
> git clone https://github.com/RapidSOS/era-ios.git
```

3. Open the project workspace: 'EmergencyReferenceApp.xcworkspace'

4. Build and Run the project.

## Guide

The [ERA Guide](/GUIDE.md) will walk you through the different parts of the Emergency Reference App.

## Emergency Data SDK

The [RapidSOS Emergency Data SDK](/RSOSData/README.md) allows applications to easily add and edit their user's Emergency Data. This Emergency Data will be made available to verified public safety officials in the event that the user experiences an emergency -- for example, if they call 9-1-1.

For more information on the Emergency Data SDK, please see the [Emergency SDK Guide](/RSOSData/README.md).

