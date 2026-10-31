
# Hotel Reservation System Database Design

## 1. Entities

The Hotel Reservation System uses three main entities (tables) to store and manage its records:

1. **Guest:** Stores information about people who make hotel reservations.
2. **Room:** Stores hotel room details, including room numbers, room types and operational status.
3. **Reservation:** Stores booking details, including the guest, allocated room, reservation dates and booking status.

These three entities support the agreed operations without introducing unnecessary tables. A separate staff entity is not required because staff authentication and payroll are outside the project scope.

## 2. Attributes and keys

The database uses PostgreSQL data types.

### A. Guest

| Attribute | PostgreSQL type | Requirement |
|---|---|---|
| guest_id (PK) | BIGINT | Required, unique |
| full_name | VARCHAR(100) | Required |
| email | VARCHAR(150) | Required, unique |
| phone | VARCHAR(20) | Optional |

The guest ID uniquely identifies each guest. Email addresses are also unique to prevent duplicate guest records.

### B. Room

| Attribute | PostgreSQL type | Requirement |
|---|---|---|
| room_id (PK) | BIGINT | Required, unique |
| room_number | VARCHAR(10) | Required, unique |
| room_type | VARCHAR(20) | Required |
| room_status | VARCHAR(20) | Required |

Room types include Single, Double and Suite. Room status indicates whether a room is Available, Maintenance or Out_of_Service.

### C. Reservation

| Attribute | PostgreSQL type | Requirement |
|---|---|---|
| reservation_id (PK) | BIGINT | Required, unique |
| guest_id (FK) | BIGINT | Required |
| room_id (FK) | BIGINT | Required |
| check_in_date | DATE | Required |
| check_out_date | DATE | Required |
| status | VARCHAR(20) | Required |
| checked_in_at | TIMESTAMPTZ | Optional |
| checked_out_at | TIMESTAMPTZ | Optional |

The guest ID and room ID are foreign keys referencing existing Guest and Room records. The timestamps record actual check-in and check-out events.

## 3. Relationships

The database has two one-to-many relationships:

1. **Guest to Reservation:** One guest can have zero or many reservations. Each reservation must belong to exactly one guest. A guest can exist without making a reservation.

2. **Room to Reservation:** One room can have zero or many reservations over time. Each reservation must be assigned to exactly one room. A room can exist without having any reservations.

A linking table is unnecessary because each reservation belongs to one guest and one room. The Reservation table connects both entities through foreign keys.

## 4. Business rules and constraints

1. **Guest identification:** The guest ID is the primary key, while email has a UNIQUE constraint. A guest can have multiple reservations.

2. **Room identification:** The room number has a UNIQUE constraint. Room type and room status use CHECK constraints to restrict values to approved options.

3. **Reservation identification:** The reservation ID is the primary key. The guest ID is a foreign key with a NOT NULL constraint, ensuring every reservation references an existing guest.

4. **Room allocation:** The room ID is a required foreign key referencing an existing room. A room can have multiple reservations over time.

5. **Reservation dates:** A CHECK constraint ensures that the check-out date is later than the check-in date. The DATE data type ensures valid calendar dates.

6. **Preventing double-booking:** An exclusion constraint using PostgreSQL date ranges prevents overlapping active reservations for the same room. This requires more than a primary key or foreign key.

7. **Reservation status:** A CHECK constraint restricts status to Pending, Confirmed, Checked-in, Checked-out or Cancelled. An update operation prevents cancelled reservations from being checked in.

8. **Check-in and check-out:** An operation verifies that a reservation is Confirmed and its room is Available before check-in. Actual timestamps record both events, while status updates prevent repeated check-outs. These cross-table and transaction rules require additional operation-level validation.

## 5. Design assumptions

1. Each reservation covers one room and one guest. Multiple rooms require separate reservations.
2. Pending, Confirmed and Checked-in reservations count as active when preventing overlapping bookings.
3. Room availability depends on both its operational status and existing reservations. Availability is calculated from booking dates rather than stored as a separate value.
