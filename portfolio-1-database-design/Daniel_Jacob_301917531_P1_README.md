
# Portfolio 1 Database Design and Modelling

## Case study

A hotel reservation system manages guest information, room records, room availability and booking history for a single hotel. Guests make reservations for available rooms over specified dates, while hotel staff manage bookings, check-ins, check-outs and room status. The system maintains reservation records to prevent double-booking and support accurate room allocation.

## Users

Guests make room reservations and provide their personal details. Receptionists register guests, create and update reservations, allocate rooms, and record check-ins and check-outs. Hotel managers review reservations, monitor room availability and access booking records.

## Main operations

The system supports registering a guest; adding and updating room records; checking room availability for selected dates; creating a reservation; modifying or cancelling an existing reservation; recording guest check-in and check-out; and viewing reservation history and current room occupancy.

## Business rules

1. Each guest must have a unique guest ID and email address. A guest may have multiple reservations over time.
2. Each room must have a unique room number and a defined room type, such as Single, Double or Suite.
3. Each reservation must have a unique reservation ID and belong to one existing guest.
4. Each reservation must be assigned to one existing room. A room can have multiple reservations over time.
5. The check-in date must be earlier than the check-out date. Both dates must be valid calendar dates.
6. A room cannot have overlapping active reservations. A new reservation must only be created when the room is available for the requested dates.
7. Each reservation must have a valid status: Pending, Confirmed, Checked-in, Checked-out or Cancelled. Cancelled reservations cannot be checked in.
8. A room can only be checked in when its reservation is confirmed and the room is available. A reservation can only be checked out once, and its booking history must be retained.

## Scope

The system covers one hotel, fictional guest records, room management, room availability, reservations, booking modifications, cancellations, check-ins and check-outs. Payments, restaurant services, housekeeping management, staff payroll, multiple hotel branches, online payment gateways and user authentication are excluded.

## Assumptions to confirm

The proposed design assumes one hotel, one room per reservation, unique guest email addresses, and five reservation statuses. It also assumes that overlapping active bookings are prohibited and that cancelled or completed reservations remain in the database for historical records.
