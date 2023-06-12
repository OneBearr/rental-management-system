<!DOCTYPE html>
<html>
<head>
    <title>Available Properties</title>
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
    <h1>Available Properties</h1>

    <?php
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

    // SQL query to fetch available properties in ascending order by ID
    $query = "SELECT p.id, p.name AS pName, p.ownerId, o.name AS oName, p.addressId,
					a.street || ', ' || a.city || ', ' || a.zipcode AS property_address,
					p.rooms, p.monthlyRent, p.availability, p.startDate, p.supervisorId, p.branchId
				FROM property p
				JOIN Owner o ON p.ownerId = o.id
				JOIN Address a ON p.addressId = a.id
				WHERE p.availability = 'Available'
				ORDER BY p.id";
    // Prepare the query
    $stmt = oci_parse($conn, $query);

    // Execute the query
    oci_execute($stmt);

    // Fetch and display the properties
    echo '<table>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Owner ID</th>
				<th>Owner Name</th>
                <th>Address ID</th>
				<th>Address</th>
                <th>Rooms</th>
                <th>Monthly Rent</th>
                <th>Availability</th>
                <th>Start Date</th>
                <th>Supervisor ID</th>
                <th>Branch ID</th>
            </tr>';

    while ($row = oci_fetch_array($stmt, OCI_ASSOC)) {
        echo '<tr>';
        foreach ($row as $value) {
            echo '<td>' . $value . '</td>';
        }
    }

    echo '</table>';
	echo '<br><a href="create_agreement.php">Create a New Lease Agreement</a><br>
	<br><a href="index.php">Main Menu</a>';
    // Close the connection
    oci_close($conn);
    ?>
	
</body>
</html>
