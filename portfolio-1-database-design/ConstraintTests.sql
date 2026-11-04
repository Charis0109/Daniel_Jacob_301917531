
-- MIT 8103 Portfolio 1
-- Hotel Reservation System Constraint Tests
-- PostgreSQL 16
--
-- Run after SampleData.sql.
-- Each invalid INSERT is expected to fail.
-- Run this file with psql's default error handling
-- so that later tests continue after expected errors.

-- TEST 1: Guest full_name cannot be NULL
INSERT INTO public.guest (full_name, email)
VALUES (NULL, 'null.name@example.com');

-- TEST 2: Guest email cannot be NULL
INSERT INTO public.guest (full_name, email)
VALUES ('Test Guest', NULL);

-- TEST 3: Guest email must be unique
INSERT INTO public.guest (full_name, email)
VALUES ('Duplicate Email', 'ada.james@example.com');

-- TEST 4: Guest primary key must be unique
INSERT INTO public.guest (guest_id, full_name, email)
OVERRIDING SYSTEM VALUE
VALUES (1, 'Duplicate ID', 'duplicate.id@example.com');

-- TEST 5: Room number cannot be NULL
INSERT INTO public.room (room_number, room_type, room_status)
VALUES (NULL, 'Single', 'Available');

-- TEST 6: Room number must be unique
INSERT INTO public.room (room_number, room_type, room_status)
VALUES ('101', 'Double', 'Available');

-- TEST 7: Room type must be valid
INSERT INTO public.room (room_number, room_type, room_status)
VALUES ('105', 'Penthouse', 'Available');

-- TEST 8: Room status must be valid
INSERT INTO public.room (room_number, room_type, room_status)
VALUES ('106', 'Single', 'Occupied');

-- TEST 9: Reservation guest_id cannot be NULL
INSERT INTO public.reservation
    (guest_id, room_id, check_in_date, check_out_date, status)
VALUES
    (NULL, 1, '2026-12-01', '2026-12-03', 'Pending');

-- TEST 10: Reservation room_id cannot be NULL
INSERT INTO public.reservation
    (guest_id, room_id, check_in_date, check_out_date, status)
VALUES
    (1, NULL, '2026-12-01', '2026-12-03', 'Pending');

-- TEST 11: Guest foreign key must exist
INSERT INTO public.reservation
    (guest_id, room_id, check_in_date, check_out_date, status)
VALUES
    (99999, 1, '2026-12-01', '2026-12-03', 'Pending');

-- TEST 12: Room foreign key must exist
INSERT INTO public.reservation
    (guest_id, room_id, check_in_date, check_out_date, status)
VALUES
    (1, 99999, '2026-12-01', '2026-12-03', 'Pending');

-- TEST 13: Check-out date must be after check-in date
INSERT INTO public.reservation
    (guest_id, room_id, check_in_date, check_out_date, status)
VALUES
    (1, 1, '2026-12-05', '2026-12-05', 'Pending');

-- TEST 14: Reservation status must be valid
INSERT INTO public.reservation
    (guest_id, room_id, check_in_date, check_out_date, status)
VALUES
    (1, 1, '2026-12-10', '2026-12-12', 'Booked');

-- TEST 15: Active reservations cannot overlap for the same room
INSERT INTO public.reservation
    (guest_id, room_id, check_in_date, check_out_date, status)
VALUES
    (1, 2, '2026-11-16', '2026-11-18', 'Confirmed');

-- TEST 16: Cancelled reservations may overlap an existing booking
-- This is a positive control test and should succeed.
INSERT INTO public.reservation
    (guest_id, room_id, check_in_date, check_out_date, status)
VALUES
    (1, 2, '2026-11-16', '2026-11-18', 'Cancelled');

-- Final record counts
SELECT
    (SELECT COUNT(*) FROM public.guest) AS total_guests,
    (SELECT COUNT(*) FROM public.room) AS total_rooms,
    (SELECT COUNT(*) FROM public.reservation) AS total_reservations;
