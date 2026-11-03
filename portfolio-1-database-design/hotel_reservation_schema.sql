
-- MIT 8103 Portfolio 1
-- Hotel Reservation System Database Schema
-- PostgreSQL 16

BEGIN;

-- Guest table
CREATE TABLE public.guest (
    guest_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20)
);

-- Room table
CREATE TABLE public.room (
    room_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type VARCHAR(20) NOT NULL,
    room_status VARCHAR(20) NOT NULL,

    CONSTRAINT chk_room_type
        CHECK (room_type IN ('Single', 'Double', 'Suite')),

    CONSTRAINT chk_room_status
        CHECK (room_status IN ('Available', 'Maintenance', 'Out_of_Service'))
);

-- Enable support for the room booking exclusion constraint
CREATE EXTENSION btree_gist;

-- Reservation table
CREATE TABLE public.reservation (
    reservation_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    guest_id BIGINT NOT NULL,
    room_id BIGINT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    checked_in_at TIMESTAMPTZ,
    checked_out_at TIMESTAMPTZ,

    CONSTRAINT fk_reservation_guest
        FOREIGN KEY (guest_id)
        REFERENCES public.guest (guest_id),

    CONSTRAINT fk_reservation_room
        FOREIGN KEY (room_id)
        REFERENCES public.room (room_id),

    CONSTRAINT chk_reservation_dates
        CHECK (check_out_date > check_in_date),

    CONSTRAINT chk_reservation_status
        CHECK (status IN (
            'Pending',
            'Confirmed',
            'Checked-in',
            'Checked-out',
            'Cancelled'
        )),

    -- Prevent overlapping active bookings for the same room
    CONSTRAINT ex_room_active_reservations
        EXCLUDE USING GIST (
            room_id WITH =,
            daterange(check_in_date, check_out_date, '[)') WITH &&
        )
        WHERE (status IN ('Pending', 'Confirmed', 'Checked-in'))
);

-- Additional operation-level validation is required for:
-- 1. Checking in only confirmed reservations with available rooms.
-- 2. Preventing cancelled reservations from being checked in.
-- 3. Preventing repeated check-outs.
-- 4. Updating check-in and check-out timestamps correctly.
-- 5. Checking room operational status when determining availability.

COMMIT;
