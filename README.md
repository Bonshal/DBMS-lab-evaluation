# Transport Management System (DBMS Project)

A complete and well-structured **MySQL-based Transport Management System** designed to manage vehicles, routes, staff, trips, bookings, passengers, payments, fare rules, seat allocations, and maintenance records.

This project includes **17 normalized tables**, realistic constraints, foreign keys, sample data, and is fully suitable for DBMS lab evaluation or college mini-projects.

---

## 📌 Project Overview

This Transport Management System models real-world operations such as:

- Managing vehicle types (Bus, Van, Cab, etc.)
- Operator/company and staff management  
- Creating locations and route mapping  
- Trip scheduling and seat management  
- Passenger and booking system  
- Payment processing  
- Dynamic fare calculation  
- Vehicle maintenance logging  
- Trip reviews and cancellation handling  

---

## 🗂 Database Tables (17 Total)

### **Core Entities**
1. `vehicle_types`  
2. `operators`  
3. `staff`  
4. `locations`  
5. `routes`  
6. `vehicles`  
7. `trips`  
8. `passengers`  

### **Booking & Ticketing**
9. `bookings`  
10. `payments`  
11. `cancellations`  

### **Seat Management**
12. `seats`  
13. `trip_seat_allocations`  

### **Fare & Pricing**
14. `fares`  

### **Maintenance**
15. `maintenance_logs`  

### **Feedback**
16. `reviews`  

### **(Optional)**
17. `audit_logs` *(if added)*  

---

## 🔗 Table Relationships

- **vehicles** ↔ `vehicle_types`, `operators`, `seats`, `maintenance_logs`
- **routes** ↔ `locations`
- **trips** ↔ `routes`, `vehicles`, `staff`
- **bookings** ↔ `trips`, `passengers`
- **payments** ↔ `bookings`
- **trip_seat_allocations** ↔ `seats`, `bookings`
- **reviews** ↔ `bookings`
- **cancellations** ↔ `bookings`

The schema uses foreign keys, cascading rules, ENUMs, and check constraints to ensure integrity.

---

## 🚀 How to Set Up

### 1️⃣ Create a database
```sql
CREATE DATABASE transport_db;
USE transport_db;
