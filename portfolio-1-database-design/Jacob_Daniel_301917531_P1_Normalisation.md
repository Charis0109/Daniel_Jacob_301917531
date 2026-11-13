
# Hotel Reservation System Database Design Normalisation

Normalisation separates information into related tables to reduce repeated details and prevent inconsistent updates. The Hotel Reservation System uses three main tables: Guest, Room and Reservation. The same fictional guest, room and reservation records are used throughout the examples.

The examples show selected fields for readability. The complete design retains all attributes from the database design document.

## Starting reservation list

The starting record contains guest details, room details and reservation information in one table. Ada has two reservations, while Ben has one.

| **guest_id** | **full_name** | **email** | **Reservations** |
|---|---|---|---|
| 1 | Ada James | ada@example.com | Reservation 1001: Room 101, Single, 2026-11-01 to 2026-11-03, Confirmed; Reservation 1002: Room 102, Double, 2026-11-10 to 2026-11-12, Pending |
| 2 | Ben Cole | ben@example.com | Reservation 1003: Room 101, Single, 2026-11-15 to 2026-11-17, Confirmed |

The Reservations column contains multiple bookings in one cell. This makes it difficult to search for a particular reservation, update its status or check room availability.

## 1NF: One value per cell

First Normal Form (1NF) requires each cell to contain one value and each record to represent one reservation.

The repeated reservation lists are separated into individual rows.

| **guest_id** | **full_name** | **email** | **room_id** | **room_number** | **room_type** | **reservation_id** | **check_in_date** | **check_out_date** | **status** |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Ada James | ada@example.com | 10 | 101 | Single | 1001 | 2026-11-01 | 2026-11-03 | Confirmed |
| 1 | Ada James | ada@example.com | 11 | 102 | Double | 1002 | 2026-11-10 | 2026-11-12 | Pending |
| 2 | Ben Cole | ben@example.com | 10 | 101 | Single | 1003 | 2026-11-15 | 2026-11-17 | Confirmed |

**Key:** `reservation_id` uniquely identifies each reservation.

The table now satisfies 1NF because each reservation occupies one row and each cell contains a single value.

However, guest details and room details are repeated. For example, Ada's name and email appear twice, while Room 101 details appear in two reservations. Updating these details requires changing multiple rows.

## 2NF: Details depend on the whole key

Second Normal Form (2NF) includes 1NF. Every non-key field must depend on the whole primary key, not just part of a combined key.

To demonstrate the issue, consider a temporary combined key of **(guest_id, room_id, check_in_date)**. This identifies a reservation under the assumption that the same guest cannot reserve the same room twice for the same check-in date.

Two partial dependencies exist:

- `guest_id` determines `full_name` and `email`.
- `room_id` determines `room_number` and `room_type`.

A partial dependency occurs when a field depends on only part of a combined key. These details move into separate tables.

### Guest details

Key: **guest_id**.

| **guest_id** | **full_name** | **email** |
|---|---|---|
| 1 | Ada James | ada@example.com |
| 2 | Ben Cole | ben@example.com |

### Room details

Key: **room_id**.

| **room_id** | **room_number** | **room_type** |
|---|---|---|
| 10 | 101 | Single |
| 11 | 102 | Double |

### Reservation details

Key: **(guest_id, room_id, check_in_date)**.

| **guest_id** | **room_id** | **check_in_date** | **check_out_date** | **status** |
|---|---|---|---|---|
| 1 | 10 | 2026-11-01 | 2026-11-03 | Confirmed |
| 1 | 11 | 2026-11-10 | 2026-11-12 | Pending |
| 2 | 10 | 2026-11-15 | 2026-11-17 | Confirmed |

The guest and room details no longer repeat in every reservation. The foreign keys connect the Reservation table to the Guest and Room tables.

This removes the need to update a guest's email or a room's type in several reservation records.

## 3NF: Keep details with the thing they describe

Third Normal Form (3NF) includes 2NF. Non-key fields must depend on the key, the whole key and nothing but the key.

A transitive dependency occurs when a non-key field depends on another non-key field instead of directly depending on the primary key.

In this hotel system, the guest name and email depend on `guest_id`, while the room number and room type depend on `room_id`. These dependencies are already separated in the 2NF tables.

There is no additional transitive dependency among the remaining reservation fields in the agreed design. Therefore, no further table split is necessary.

### Guest

Key: **guest_id**.

| **guest_id** | **full_name** | **email** | **phone** |
|---|---|---|---|
| 1 | Ada James | ada@example.com | 08012345678 |
| 2 | Ben Cole | ben@example.com | 08098765432 |

### Room

Key: **room_id**.

| **room_id** | **room_number** | **room_type** | **room_status** |
|---|---|---|---|
| 10 | 101 | Single | Available |
| 11 | 102 | Double | Available |

### Reservation

The final design uses **reservation_id** as its primary key instead of the temporary combined key used in the 2NF example. The guest_id and room_id fields remain foreign keys.

| **reservation_id** | **guest_id** | **room_id** | **check_in_date** | **check_out_date** | **status** |
|---|---|---|---|---|---|
| 1001 | 1 | 10 | 2026-11-01 | 2026-11-03 | Confirmed |
| 1002 | 1 | 11 | 2026-11-10 | 2026-11-12 | Pending |
| 1003 | 2 | 10 | 2026-11-15 | 2026-11-17 | Confirmed |

The final Reservation table also includes `checked_in_at` and `checked_out_at`, which are optional TIMESTAMPTZ fields used to record actual check-in and check-out times.

The automatically generated reservation ID provides a simple, unique identifier for each booking. Using an ID alone does not prove that a table is in 3NF; the separation of guest, room and reservation details establishes the required structure.

## Final normalised design

The final database contains three tables:

1. **Guest:** Stores guest identification and contact information.
2. **Room:** Stores room numbers, room types and operational status.
3. **Reservation:** Stores booking dates, reservation status and links to the relevant guest and room.

The IDs preserve the relationships between the tables. For example, Reservation 1001 references Guest 1 and Room 10. The database can retrieve the guest's details and room information through these relationships without storing the same information repeatedly.

The complete design also retains unique email addresses, unique room numbers, required foreign keys, valid date checks, reservation status restrictions and the exclusion constraint that prevents overlapping active reservations.

Normalisation reduces duplication and improves data consistency, but it does not automatically enforce every business rule. Date validation, double-booking prevention and check-in/check-out operations still require appropriate database constraints and transaction logic.
