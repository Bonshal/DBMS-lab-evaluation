# DBMS-lab-evaluation
DBMS lab evaluation

# Transport Management System (DBMS Project)

A simple and well‑structured MySQL-based **Transport Management System** designed for managing buses, cabs, vans, routes, trips, bookings, passengers, and payments.  
The project contains **9 interlinked tables**, foreign keys, constraints, and sample data.

---

## 📌 Project Overview
This system helps manage everyday transport operations, including:

- Vehicle types (Bus, Cab, Van, etc.)
- Vehicle registration & operator management
- Route management (origin → destination)
- Trip scheduling for vehicles
- Passenger records
- Booking ticketing system
- Payment tracking

---

## 🗂 Database Tables (9 Total)

1. **vehicle_types** – Stores vehicle categories  
2. **operators** – Transport companies or owners  
3. **locations** – Cities, stops, or terminals  
4. **routes** – Connects two locations with distance & duration  
5. **vehicles** – Registered vehicles with type & operator  
6. **trips** – Scheduled travel instances  
7. **passengers** – Customer information  
8. **bookings** – Passenger bookings for trips  
9. **payments** – Payment records for bookings  

---

## 🔗 Table Relationships
- **Vehicles** → linked with **Vehicle Types** and **Operators**  
- **Routes** → linked with **Locations** (Origin & Destination)  
- **Trips** → linked with **Routes** and **Vehicles**  
- **Bookings** → linked with **Trips** and **Passengers**  
- **Payments** → linked with **Bookings**  

Relationships maintain consistent and valid data.

---

## 🚀 How to Use

1. Create and open a database:
   ```sql
   CREATE DATABASE transport_db;
   USE transport_db;
   ```
2. Import the SQL file:
   ```
   SOURCE transport_management.sql;
   ```

Your database will now be ready with all tables and sample data.

---

## 📁 Files Included
- `transport_management.sql` – Main database schema  
- `README.md` – Description and setup guide  

---

## ✨ Optional Enhancements
Consider adding:

- Route stop sequence table  
- Stored procedures for booking automation  
- Triggers for auto-updating seat availability  
- Views for available trips  
- Admin login & user roles  

---

## 📚 Suitable For
- End-semester DBMS project  
- College mini project  
- SQL & database design practice  
- Backend development learning  

---


