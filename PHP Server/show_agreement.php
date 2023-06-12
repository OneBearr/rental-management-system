<!DOCTYPE html>
<html>
<head>
    <title>Show Lease Agreement</title>
    <style>
        table {
            border-collapse: collapse;
        }
        
        table, th, td {
            border: 1px solid black;
            padding: 5px;
        }
    </style>
</head>
<body>
    <h1>Show Lease Agreement</h1>

    <form method="POST" action="">
        <label for="renter_home_phone">Renter Home Phone:</label>
        <input type="text" name="renter_home_phone" required><br>
        <input type="submit" value="Show Agreements">
    </form><br>

    <?php
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Get renter home phone number from the form
        $renterHomePhone = $_POST['renter_home_phone'];

        // Database connection details
        $username = 'xyi';
        $password = 'oracle_pwd';
        $dbname = '//oracle.engr.scu.edu/db11g';

        // Create a connection to the database
        $conn = oci_connect($username, $password, $dbname);

        if (!$conn) {
            $e = oci_error();
            trigger_error(htmlentities($e['message'], ENT_QUOTES), E_USER_ERROR);
        }

        // Prepare the SQL statement
        $query = "SELECT a.id AS agreement_id,
                        p.name AS property_name,
                        ad.street || ', ' || ad.city || ', ' || ad.zipcode AS property_address,
                        a.rentername AS renter_name,
                        a.renterhome# AS renter_home#,
                        a.renterwork# AS renter_work#,
                        a.startdate AS start_date,
                        a.enddate AS end_date,
                        a.deposit,
                        a.monthlyrent AS monthly_rent
                FROM agreement a
                JOIN property p ON a.propertyid = p.id
                JOIN address ad ON p.addressid = ad.id
                WHERE a.renterhome# = :renterHomePhone";

        // Prepare the statement
        $stmt = oci_parse($conn, $query);

        // Bind the parameter
        oci_bind_by_name($stmt, ':renterHomePhone', $renterHomePhone);

        // Execute the statement
        oci_execute($stmt);

        echo '<table>
                <tr>
                    <th>Agreement ID</th>
                    <th>Property Name</th>
                    <th>Property Address</th>
                    <th>Renter Name</th>
                    <th>Renter Home Phone</th>
                    <th>Renter Work Phone</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Deposit</th>
                    <th>Monthly Rent</th>
                </tr>';

            while ($row = oci_fetch_array($stmt, OCI_ASSOC)) {
                echo '<tr>';
                foreach ($row as $value) {
                    echo '<td>' . $value . '</td>';
                }
            }
            echo '</table>';

        echo '<br><a href="index.php">Main Menu</a>';
        // Close the statement and connection
        oci_free_statement($stmt);
        oci_close($conn);
    }
    
    ?>
    
</body>
</html>

