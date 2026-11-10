CREATE DATABASE IT_Service_Desk;
USE IT_Service_Desk;
CREATE TABLE Tickets (
    Ticket_ID INT PRIMARY KEY,
    Created_Date DATETIME,
    Resolved_Date DATETIME,
    Priority VARCHAR(20),
    Category VARCHAR(50),
    Subcategory VARCHAR(50),
    Department VARCHAR(50),
    Technician VARCHAR(50),
    Status VARCHAR(20),
    SLA_Hours INT,
    Resolution_Hours DECIMAL(10,2)
);
CREATE TABLE SLA_Targets (
    Priority VARCHAR(20) PRIMARY KEY,
    Target_Hours INT
);
INSERT INTO SLA_Targets (Priority, Target_Hours)
VALUES
('Critical', 4),
('High', 8),
('Medium', 24),
('Low', 48);
INSERT INTO Tickets
(Ticket_ID, Created_Date, Resolved_Date, Priority, Category, Subcategory, Department, Technician, Status, SLA_Hours, Resolution_Hours)
VALUES
(1001, '2026-01-02 09:15:00', '2026-01-02 11:30:00', 'Critical', 'Network', 'Internet Down', 'Finance', 'Arun', 'Closed', 4, 2.25),
(1002, '2026-01-03 10:20:00', '2026-01-03 17:10:00', 'High', 'Hardware', 'Laptop Issue', 'HR', 'Priya', 'Closed', 8, 6.83),
(1003, '2026-01-04 08:45:00', '2026-01-05 12:30:00', 'Medium', 'Software', 'Application Error', 'Sales', 'Rahul', 'Closed', 24, 27.75),
(1004, '2026-01-05 14:10:00', '2026-01-06 13:00:00', 'Medium', 'Access', 'Password Reset', 'IT', 'Sneha', 'Closed', 24, 22.83),
(1005, '2026-01-06 16:30:00', '2026-01-08 18:00:00', 'Low', 'Hardware', 'Printer Issue', 'Operations', 'Arun', 'Closed', 48, 49.50);
INSERT INTO Tickets
(Ticket_ID, Created_Date, Resolved_Date, Priority, Category, Subcategory, Department, Technician, Status, SLA_Hours, Resolution_Hours)
VALUES
(1006, '2026-01-09 09:00:00', '2026-01-09 12:15:00', 'Critical', 'Security', 'Account Compromise', 'IT', 'Priya', 'Closed', 4, 3.25),
(1007, '2026-01-10 11:40:00', '2026-01-11 10:20:00', 'High', 'Network', 'VPN Issue', 'Sales', 'Rahul', 'Closed', 8, 22.67),
(1008, '2026-01-12 13:25:00', '2026-01-12 19:00:00', 'Medium', 'Software', 'System Error', 'Finance', 'Sneha', 'Closed', 24, 5.58),
(1009, '2026-01-14 15:10:00', '2026-01-16 16:30:00', 'Low', 'Hardware', 'Keyboard Issue', 'HR', 'Arun', 'Closed', 48, 49.33),
(1010, '2026-01-15 10:30:00', NULL, 'High', 'Access', 'System Access', 'Operations', 'Priya', 'Open', 8, NULL);
SELECT * from Tickets;
SELECT COUNT(*) AS
TOTAL_TICKETS
FROM Tickets;
SELECT
    Status,
    COUNT(*) AS Ticket_Count
FROM Tickets
GROUP BY Status;
SELECT
    Priority,
    COUNT(*) AS Ticket_Count
FROM Tickets
GROUP BY Priority
ORDER BY Ticket_Count DESC;
SELECT
    Ticket_ID,
    Priority,
    Department,
    Technician,
    SLA_Hours,
    Resolution_Hours
FROM Tickets
WHERE Resolution_Hours > SLA_Hours;
SELECT
    COUNT(*) AS SLA_Breaches
FROM Tickets
WHERE Resolution_Hours > SLA_Hours;
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN Resolution_Hours <= SLA_Hours THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS SLA_Compliance_Percentage
FROM Tickets
WHERE Status = 'Closed';
SELECT
    ROUND(AVG(Resolution_Hours), 2) AS Average_Resolution_Hours
FROM Tickets
WHERE Status = 'Closed';
SELECT
    Technician,
    COUNT(*) AS Tickets_Handled,
    ROUND(AVG(Resolution_Hours), 2) AS Avg_Resolution_Hours
FROM Tickets
WHERE Status = 'Closed'
GROUP BY Technician
ORDER BY Tickets_Handled DESC;
SELECT
    Department,
    COUNT(*) AS Ticket_Count,
    ROUND(AVG(Resolution_Hours), 2) AS Avg_Resolution_Hours
FROM Tickets
GROUP BY Department
ORDER BY Ticket_Count DESC;
SELECT
    Category,
    COUNT(*) AS Ticket_Count,
    ROUND(AVG(Resolution_Hours), 2) AS Avg_Resolution_Hours
FROM Tickets
GROUP BY Category
ORDER BY Ticket_Count DESC;
SELECT
    Subcategory,
    COUNT(*) AS Issue_Count
FROM Tickets
GROUP BY Subcategory
ORDER BY Issue_Count DESC;
SELECT
    Priority,
    COUNT(*) AS Total_Tickets,
    SUM(CASE
        WHEN Resolution_Hours > SLA_Hours THEN 1
        ELSE 0
    END) AS SLA_Breaches
FROM Tickets
WHERE Status = 'Closed'
GROUP BY Priority
ORDER BY SLA_Breaches DESC;
SELECT
    Priority,
    COUNT(*) AS Total_Tickets,
    SUM(CASE
        WHEN Resolution_Hours > SLA_Hours THEN 1
        ELSE 0
    END) AS SLA_Breaches,
    ROUND(
        100.0 * SUM(CASE
            WHEN Resolution_Hours > SLA_Hours THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS Breach_Rate_Percentage
FROM Tickets
WHERE Status = 'Closed'
GROUP BY Priority
ORDER BY Breach_Rate_Percentage DESC;
SELECT
    Department,
    COUNT(*) AS Total_Tickets,
    SUM(CASE
        WHEN Resolution_Hours > SLA_Hours THEN 1
        ELSE 0
    END) AS SLA_Breaches
FROM Tickets
WHERE Status = 'Closed'
GROUP BY Department
ORDER BY SLA_Breaches DESC;
SELECT
    t.Ticket_ID,
    t.Priority,
    s.Target_Hours,
    t.Resolution_Hours,
    CASE
        WHEN t.Resolution_Hours <= s.Target_Hours THEN 'Within SLA'
        ELSE 'SLA Breach'
    END AS SLA_Status
FROM Tickets t
JOIN SLA_Targets s
    ON t.Priority = s.Priority
WHERE t.Status = 'Closed';
SELECT
    Priority,
    COUNT(*) AS Total_Tickets,
    ROUND(AVG(Resolution_Hours), 2) AS Avg_Resolution_Hours
FROM Tickets
WHERE Status = 'Closed'
GROUP BY Priority
ORDER BY Avg_Resolution_Hours DESC;
SELECT
    DATE_FORMAT(Created_Date, '%Y-%m') AS Ticket_Month,
    COUNT(*) AS Total_Tickets
FROM Tickets
GROUP BY DATE_FORMAT(Created_Date, '%Y-%m')
ORDER BY Ticket_Month;
SELECT
    Category,
    COUNT(*) AS Ticket_Count
FROM Tickets
GROUP BY Category
ORDER BY Ticket_Count DESC
SELECT
    Technician,
    COUNT(*) AS Total_Tickets,
    SUM(CASE
        WHEN Resolution_Hours <= SLA_Hours THEN 1
        ELSE 0
    END) AS Within_SLA,
    ROUND(
        100.0 * SUM(CASE
            WHEN Resolution_Hours <= SLA_Hours THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS SLA_Compliance_Percentage
FROM Tickets
WHERE Status = 'Closed'
GROUP BY Technician
ORDER BY SLA_Compliance_Percentage DESC;
SELECT
    Department,
    COUNT(*) AS Total_Tickets,
    SUM(CASE
        WHEN Resolution_Hours > SLA_Hours THEN 1
        ELSE 0
    END) AS SLA_Breaches,
    ROUND(
        100.0 * SUM(CASE
            WHEN Resolution_Hours > SLA_Hours THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS Breach_Rate_Percentage
FROM Tickets
WHERE Status = 'Closed'
GROUP BY Department
ORDER BY Breach_Rate_Percentage DESC;
SELECT
    Ticket_ID,
    Priority,
    Department,
    Category,
    Technician,
    Resolution_Hours
FROM Tickets
WHERE Status = 'Closed'
ORDER BY Resolution_Hours DESC
LIMIT 5;
SELECT
    Department,
    COUNT(*) AS Total_Tickets,
    ROUND(AVG(Resolution_Hours), 2) AS Avg_Resolution_Hours
FROM Tickets
WHERE Status = 'Closed'
GROUP BY Department
ORDER BY Avg_Resolution_Hours DESC;
SELECT
    Ticket_ID,
    Priority,
    Category,
    Department,
    Technician,
    Status,
    Created_Date
FROM Tickets
WHERE Status = 'Open'
ORDER BY Created_Date;
SELECT
    Department,
    Category,
    COUNT(*) AS Ticket_Count
FROM Tickets
GROUP BY Department, Category
ORDER BY Department, Ticket_Count DESC;
SELECT
    COUNT(*) AS Closed_Tickets,
    SUM(CASE
        WHEN Resolution_Hours <= SLA_Hours THEN 1
        ELSE 0
    END) AS Within_SLA,
    SUM(CASE
        WHEN Resolution_Hours > SLA_Hours THEN 1
        ELSE 0
    END) AS SLA_Breaches,
    ROUND(
        100.0 * SUM(CASE
            WHEN Resolution_Hours <= SLA_Hours THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS SLA_Compliance_Percentage
FROM Tickets
WHERE Status = 'Closed';
SELECT
    Ticket_ID,
    Priority,
    Department,
    Category,
    Technician,
    Created_Date,
    Status
FROM Tickets
WHERE Status = 'Open'
ORDER BY
    CASE Priority
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        WHEN 'Low' THEN 4
    END;
    SELECT
    Department,
    COUNT(*) AS Ticket_Count
FROM Tickets
GROUP BY Department
ORDER BY Ticket_Count DESC
LIMIT 1;
SELECT
    Technician,
    COUNT(*) AS Tickets_Handled
FROM Tickets
GROUP BY Technician
ORDER BY Tickets_Handled DESC
LIMIT 1;
SELECT
    Subcategory,
    COUNT(*) AS Issue_Count
FROM Tickets
GROUP BY Subcategory
ORDER BY Issue_Count DESC
LIMIT 1;
SELECT
    t.Priority,
    COUNT(*) AS Total_Tickets,
    SUM(
        CASE
            WHEN t.Resolution_Hours <= s.Target_Hours THEN 1
            ELSE 0
        END
    ) AS Within_SLA,
    SUM(
        CASE
            WHEN t.Resolution_Hours > s.Target_Hours THEN 1
            ELSE 0
        END
    ) AS SLA_Breaches,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN t.Resolution_Hours <= s.Target_Hours THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS SLA_Compliance_Percentage
FROM Tickets t
JOIN SLA_Targets s
    ON t.Priority = s.Priority
WHERE t.Status = 'Closed'
GROUP BY t.Priority
ORDER BY SLA_Compliance_Percentage DESC;
WITH SLA_Analysis AS (
    SELECT
        t.Ticket_ID,
        t.Priority,
        t.Department,
        t.Technician,
        t.Resolution_Hours,
        s.Target_Hours,
        CASE
            WHEN t.Resolution_Hours <= s.Target_Hours
            THEN 'Within SLA'
            ELSE 'SLA Breach'
        END AS SLA_Status
    FROM Tickets t
    JOIN SLA_Targets s
        ON t.Priority = s.Priority
    WHERE t.Status = 'Closed'
)
SELECT
    SLA_Status,
    COUNT(*) AS Ticket_Count
FROM SLA_Analysis
GROUP BY SLA_Status;
SELECT
    Technician,
    COUNT(*) AS Tickets_Handled,
    RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS Technician_Rank
FROM Tickets
GROUP BY Technician
ORDER BY Technician_Rank;
WITH Department_SLA AS (
    SELECT
        Department,
        SUM(
            CASE
                WHEN Resolution_Hours > SLA_Hours THEN 1
                ELSE 0
            END
        ) AS SLA_Breaches
    FROM Tickets
    WHERE Status = 'Closed'
    GROUP BY Department
)
SELECT
    Department,
    SLA_Breaches,
    RANK() OVER (
        ORDER BY SLA_Breaches DESC
    ) AS Breach_Rank
FROM Department_SLA
ORDER BY Breach_Rank;
SELECT
    COUNT(*) AS Total_Tickets,
    SUM(CASE WHEN Status = 'Closed' THEN 1 ELSE 0 END) AS Closed_Tickets,
    SUM(CASE WHEN Status = 'Open' THEN 1 ELSE 0 END) AS Open_Tickets,
    SUM(CASE
        WHEN Status = 'Closed'
         AND Resolution_Hours > SLA_Hours
        THEN 1 ELSE 0
    END) AS SLA_Breaches,
    ROUND(
        AVG(CASE
            WHEN Status = 'Closed'
            THEN Resolution_Hours
        END),
        2
    ) AS Avg_Resolution_Hours,
    ROUND(
        100.0 * SUM(CASE
            WHEN Status = 'Closed'
             AND Resolution_Hours <= SLA_Hours
            THEN 1 ELSE 0
        END)
        /
        NULLIF(SUM(CASE WHEN Status = 'Closed' THEN 1 ELSE 0 END), 0),
        2
    ) AS SLA_Compliance_Percentage
FROM Tickets;
SELECT
    Department,
    COUNT(*) AS Total_Tickets,
    SUM(
        CASE
            WHEN Resolution_Hours > SLA_Hours THEN 1
            ELSE 0
        END
    ) AS SLA_Breaches
FROM Tickets
WHERE Status = 'Closed'
GROUP BY Department
ORDER BY SLA_Breaches DESC
LIMIT 3;
SELECT COUNT(*) AS
TOTAL_TICKETS FROM Tickets;
SELECT COUNT(*) AS SLA_Rows FROM SLA_Targets;
SELECT
    Status,
    COUNT(*) AS Ticket_Count
FROM Tickets
GROUP BY Status;
SELECT
    Priority,
    COUNT(*) AS Ticket_Count
FROM Tickets
GROUP BY Priority
ORDER BY Ticket_Count DESC;
SELECT
    Ticket_ID,
    Priority,
    Resolution_Hours,
    SLA_Hours
FROM Tickets
WHERE Resolution_Hours > SLA_Hours;
SELECT
    ROUND(
        SUM(CASE WHEN Resolution_Hours <= SLA_Hours THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS SLA_Compliance_Percentage
FROM Tickets
WHERE Status = 'Closed';
SELECT
    ROUND(AVG(Resolution_Hours), 2) AS Average_Resolution_Hours
FROM Tickets
WHERE Status = 'Closed';
SELECT
    Department,
    COUNT(*) AS Ticket_Count,
    SUM(CASE WHEN Resolution_Hours > SLA_Hours THEN 1 ELSE 0 END) AS SLA_Breaches
FROM Tickets
GROUP BY Department
ORDER BY SLA_Breaches DESC;
SELECT
    Category,
    COUNT(*) AS Ticket_Count,
    SUM(CASE WHEN Resolution_Hours > SLA_Hours THEN 1 ELSE 0 END) AS SLA_Breaches
FROM Tickets
GROUP BY Category
ORDER BY Ticket_Count DESC;
SELECT
    Technician,
    COUNT(*) AS Ticket_Count,
    SUM(CASE WHEN Resolution_Hours > SLA_Hours THEN 1 ELSE 0 END) AS SLA_Breaches,
    ROUND(AVG(Resolution_Hours), 2) AS Avg_Resolution_Hours
FROM Tickets
WHERE Status = 'Closed'
GROUP BY Technician
ORDER BY SLA_Breaches DESC;
SELECT
    Subcategory,
    COUNT(*) AS Issue_Count
FROM Tickets
GROUP BY Subcategory
ORDER BY Issue_Count DESC;
SELECT
    Priority,
    COUNT(*) AS Ticket_Count,
    SUM(CASE WHEN Resolution_Hours > SLA_Hours THEN 1 ELSE 0 END) AS SLA_Breaches,
    ROUND(
        SUM(CASE WHEN Resolution_Hours > SLA_Hours THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS Breach_Rate_Percentage
FROM Tickets
WHERE Status = 'Closed'
GROUP BY Priority
ORDER BY Breach_Rate_Percentage DESC;
SELECT
    Department,
    COUNT(*) AS Ticket_Count,
    SUM(CASE WHEN Resolution_Hours > SLA_Hours THEN 1 ELSE 0 END) AS SLA_Breaches,
    ROUND(
        SUM(CASE WHEN Resolution_Hours > SLA_Hours THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS Breach_Rate_Percentage
FROM Tickets
WHERE Status = 'Closed'
GROUP BY Department
ORDER BY Breach_Rate_Percentage DESC;
SELECT
    Ticket_ID,
    Priority,
    Department,
    Technician,
    Resolution_Hours
FROM Tickets
WHERE Status = 'Closed'
ORDER BY Resolution_Hours DESC
LIMIT 5;
SELECT
    Ticket_ID,
    Priority,
    Category,
    Department,
    Technician,
    Status,
    SLA_Hours
FROM Tickets
WHERE Status = 'Open';
SELECT
    t.Ticket_ID,
    t.Priority,
    t.Resolution_Hours,
    s.Target_Hours,
    CASE
        WHEN t.Resolution_Hours <= s.Target_Hours THEN 'Within SLA'
        ELSE 'SLA Breach'
    END AS SLA_Status
FROM Tickets t
JOIN SLA_Targets s
    ON t.Priority = s.Priority
WHERE t.Status = 'Closed';
WITH SLA_Summary AS (
    SELECT
        CASE
            WHEN Resolution_Hours <= SLA_Hours THEN 'Within SLA'
            ELSE 'SLA Breach'
        END AS SLA_Status
    FROM Tickets
    WHERE Status = 'Closed'
)
SELECT
    SLA_Status,
    COUNT(*) AS Ticket_Count
FROM SLA_Summary
GROUP BY SLA_Status;
SELECT
    Technician,
    COUNT(*) AS Ticket_Count,
    SUM(CASE WHEN Resolution_Hours > SLA_Hours THEN 1 ELSE 0 END) AS SLA_Breaches,
    RANK() OVER (
        ORDER BY SUM(CASE WHEN Resolution_Hours > SLA_Hours THEN 1 ELSE 0 END) DESC
    ) AS Breach_Rank
FROM Tickets
WHERE Status = 'Closed'
GROUP BY Technician;
SELECT
    Department,
    COUNT(*) AS Ticket_Count,
    SUM(CASE WHEN Resolution_Hours > SLA_Hours THEN 1 ELSE 0 END) AS SLA_Breaches,
    RANK() OVER (
        ORDER BY SUM(CASE WHEN Resolution_Hours > SLA_Hours THEN 1 ELSE 0 END) DESC
    ) AS Breach_Rank
FROM Tickets
WHERE Status = 'Closed'
GROUP BY Department;
SELECT
    COUNT(*) AS Total_Tickets,
    SUM(CASE WHEN Status = 'Closed' THEN 1 ELSE 0 END) AS Closed_Tickets,
    SUM(CASE WHEN Status = 'Open' THEN 1 ELSE 0 END) AS Open_Tickets,
    SUM(CASE WHEN Resolution_Hours > SLA_Hours THEN 1 ELSE 0 END) AS SLA_Breaches,
    ROUND(
        SUM(CASE WHEN Resolution_Hours <= SLA_Hours THEN 1 ELSE 0 END)
        / SUM(CASE WHEN Status = 'Closed' THEN 1 ELSE 0 END) * 100,
        2
    ) AS SLA_Compliance_Percentage,
    ROUND(AVG(CASE WHEN Status = 'Closed' THEN Resolution_Hours END), 2)
        AS Avg_Resolution_Hours
FROM Tickets;
SELECT
    Department,
    COUNT(*) AS Ticket_Count,
    SUM(CASE WHEN Resolution_Hours > SLA_Hours THEN 1 ELSE 0 END) AS SLA_Breaches
FROM Tickets
GROUP BY Department
ORDER BY SLA_Breaches DESC
LIMIT 3;