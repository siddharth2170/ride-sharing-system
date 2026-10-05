"Ride Sharing System -- Pharo/Squeak file-in format"

Object subclass: #Ride
    instanceVariableNames: 'rideID pickupLocation dropoffLocation distance'
    classVariableNames: ''
    poolDictionaries: ''
    category: 'RideSharing'!

!Ride class methodsFor: 'instance creation'!
id: anID pickup: aPickup dropoff: aDropoff distance: miles
    ^ self new initializeID: anID pickup: aPickup dropoff: aDropoff distance: miles
! !

!Ride methodsFor: 'initialization'!
initializeID: anID pickup: aPickup dropoff: aDropoff distance: miles
    miles < 0 ifTrue: [ self error: 'Distance cannot be negative' ].
    rideID := anID.
    pickupLocation := aPickup.
    dropoffLocation := aDropoff.
    distance := miles.
    ^ self
! !

!Ride methodsFor: 'accessing'!
rideID
    ^ rideID
!
distance
    ^ distance
! !

!Ride methodsFor: 'pricing'!
fare
    self subclassResponsibility
!
baseFareAt: rate bookingFee: fee
    ^ fee + (distance * rate)
! !

!Ride methodsFor: 'printing'!
rideType
    self subclassResponsibility
!
rideDetails
    ^ String streamContents: [ :stream |
        stream nextPutAll: self rideType; nextPutAll: ' ride '; nextPutAll: rideID;
            nextPutAll: ': '; nextPutAll: pickupLocation; nextPutAll: ' -> ';
            nextPutAll: dropoffLocation; nextPutAll: ', ';
            nextPutAll: distance printString; nextPutAll: ' miles, fare $';
            nextPutAll: (self fare printShowingDecimalPlaces: 2) ]
! !

Ride subclass: #StandardRide
    instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''
    category: 'RideSharing'!

!StandardRide methodsFor: 'pricing'!
fare
    ^ self baseFareAt: 2.00 bookingFee: 3.00
!
rideType
    ^ 'Standard'
! !

Ride subclass: #PremiumRide
    instanceVariableNames: '' classVariableNames: '' poolDictionaries: ''
    category: 'RideSharing'!

!PremiumRide methodsFor: 'pricing'!
fare
    ^ self baseFareAt: 3.50 bookingFee: 7.50
!
rideType
    ^ 'Premium'
! !

Object subclass: #Driver
    instanceVariableNames: 'driverID name rating assignedRides'
    classVariableNames: '' poolDictionaries: '' category: 'RideSharing'!

!Driver class methodsFor: 'instance creation'!
id: anID name: aName rating: aRating
    ^ self new initializeID: anID name: aName rating: aRating
! !

!Driver methodsFor: 'initialization'!
initializeID: anID name: aName rating: aRating
    ((aRating between: 0 and: 5) not)
        ifTrue: [ self error: 'Rating must be between 0 and 5' ].
    driverID := anID. name := aName. rating := aRating.
    assignedRides := OrderedCollection new.
    ^ self
! !

!Driver methodsFor: 'rides'!
addRide: aRide
    assignedRides add: aRide
!
completedRideCount
    ^ assignedRides size
!
getDriverInfo
    ^ 'Driver ', name, ' (', driverID, '), rating ',
      (rating printShowingDecimalPlaces: 1), '/5, completed ',
      assignedRides size printString, ' rides'
! !

Object subclass: #Rider
    instanceVariableNames: 'riderID name requestedRides'
    classVariableNames: '' poolDictionaries: '' category: 'RideSharing'!

!Rider class methodsFor: 'instance creation'!
id: anID name: aName
    ^ self new initializeID: anID name: aName
! !

!Rider methodsFor: 'initialization'!
initializeID: anID name: aName
    riderID := anID. name := aName.
    requestedRides := OrderedCollection new.
    ^ self
! !

!Rider methodsFor: 'rides'!
requestRide: aRide
    requestedRides add: aRide
!
viewRides
    ^ String streamContents: [ :stream |
        stream nextPutAll: 'Ride history for ', name, ' (', riderID, '):'; cr.
        requestedRides do: [ :ride |
            stream nextPutAll: '  - '; nextPutAll: ride rideDetails; cr ] ]
! !

"Demonstration -- evaluated automatically when filed in"
| rides driver rider |
rides := {
    StandardRide id: 'R-101' pickup: 'Campus' dropoff: 'Airport' distance: 12.5.
    PremiumRide id: 'R-102' pickup: 'Downtown' dropoff: 'Museum' distance: 6.0.
    StandardRide id: 'R-103' pickup: 'Library' dropoff: 'Station' distance: 4.25 }.
driver := Driver id: 'D-17' name: 'Maya Chen' rating: 4.9.
rider := Rider id: 'U-42' name: 'Jordan Lee'.
rides do: [ :ride | driver addRide: ride. rider requestRide: ride ].
Transcript clear; show: '=== Ride Sharing System: Smalltalk ==='; cr;
    show: driver getDriverInfo; cr; show: rider viewRides; cr;
    show: 'Polymorphic fare calculation:'; cr.
rides do: [ :ride |
    Transcript show: '  ', ride rideType, ' ', ride rideID, ' = $',
        (ride fare printShowingDecimalPlaces: 2); cr ]!
