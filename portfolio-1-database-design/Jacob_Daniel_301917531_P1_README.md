# Portfolio 1 – Database Design and Modelling

## Case Study: Hotel Reservation Management System

The system manages guest information, room records, room availability and booking history for a single hotel. Guests make reservations for available rooms over specified dates, while hotel staff manage bookings, check-ins, check-outs and room status.

## Users

- **Guests:** Make room reservations and provide their personal details.
- **Receptionists:** Register guests, create and update reservations, allocate rooms, and record check-ins and check-outs.
- **Hotel managers:** Review reservations, monitor room availability and access booking records.

## Main Operations

The system supports:
- Registering guests.
- Adding and updating room records.
- Checking room availability for selected dates.
- Creating, modifying and cancelling reservations.
- Recording guest check-in and check-out.
- Viewing reservation history and room occupancy.

## Business Rules

1. Each guest must have a unique guest ID and email address.
2. Each room must have a unique room number and a defined room type.
3. Each reservation must have a unique reservation ID and belong to one existing guest.
4. Each reservation must be assigned to one existing room.
5. The check-in date must be earlier than the check-out date.
6. A room cannot have overlapping active reservations.
7. Each reservation must have a valid status: Pending, Confirmed, Checked-in, Checked-out or Cancelled.
8. Cancelled reservations cannot be checked in. Check-in and check-out operations must follow the reservation status rules.

## Scope

The system covers one hotel, fictional guest records, room management, room availability, reservations, booking modifications, cancellations, check-ins and check-outs.

Payments, restaurant services, housekeeping management, staff payroll, multiple hotel branches, online payment gateways and user authentication are outside the project scope.

## Design Assumptions

- Each reservation covers one guest and one room.
- Multiple rooms require separate reservations.
- Pending, Confirmed and Checked-in reservations count as active when preventing overlapping bookings.
- Cancelled and completed reservations remain in the database for historical records.
- Room availability depends on operational room status and existing reservations.

## Design and Implementation Files

| File | Description |
|---|---|
| [Database Design](Jacob_Daniel_301917531_P1_Design.md) | Entities, attributes, keys, relationships and business rules. |
| [ER Diagram](Jacob_Daniel_301917531_P1_ERDiagram.md) | Entity relationships and database structure. |
| [Normalisation](Jacob_Daniel_301917531_P1_Normalisation.md) | Normalisation from the initial reservation records to the final table structure. |
| `hotel_reservation_schema.sql` | PostgreSQL statements for creating the database tables and constraints. |
| `SampleData.sql` | SQL statements for inserting fictional guest, room and reservation records. |
| `ConstraintTests.sql` | SQL statements for testing database constraints. |

## Implementation

The database was implemented using PostgreSQL 16 in a GitHub Codespace environment. The database is named `hotel_reservation_portfolio`.

The schema contains three tables: `guest`, `room` and `reservation`. Primary keys uniquely identify records, while foreign keys connect reservations to existing guests and rooms.

The implementation includes NOT NULL, UNIQUE, CHECK and FOREIGN KEY constraints. It also uses a PostgreSQL exclusion constraint to prevent overlapping active reservations for the same room.

Sample records were inserted using `SampleData.sql`, and the constraints were tested using `ConstraintTests.sql`.

## Test Results

The constraint test produced the expected results for all 16 test cases.

- Tests 1–15 were rejected as expected because they attempted to insert invalid or conflicting records.
- Test 16 was accepted because a cancelled reservation is permitted to overlap an existing active booking.

The final row-count query returned:

| Table | Records |
|---|---:|
| Guest | 3 |
| Room | 4 |
| Reservation | 6 |

These results demonstrate the operation of the implemented constraints and the handling of cancelled reservations.

## Evidence

Practical screenshots should show the actual Hotel Reservation System database, its tables, sample records and constraint test results. Only screenshots that correspond to this project should be included as evidence.
