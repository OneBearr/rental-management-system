<!DOCTYPE html>
<html>
<head>
    <title>Create a New Lease Agreement</title>
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
    
    <h1>New Lease Agreement</h1>

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

    // Handle form submission
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Get form data
        $propertyId = $_POST['property_id'];
        $renterName = $_POST['renter_name'];
        $renterHomePhone = $_POST['renter_home_phone'];
        $renterWorkPhone = $_POST['renter_work_phone'];
        $startDate = $_POST['start_date'];
        $endDate = $_POST['end_date'];
        $deposit = $_POST['deposit'];

        // Validate date length
        
        $startTimestamp = strtotime($startDate);
        $endTimestamp = strtotime($endDate);

        $today = date('Y-m-d');
        $minDate = strtotime('+6 months', $startTimestamp);
        $maxDate = strtotime('+1 year', $startTimestamp);

        if ($startDate < $today) {
            echo '<p>Invalid start date. The start date cannot be earlier than today\'s date.</p><br>
            <br><a href="create_agreement.php">Go Back</a>';
            exit;
        } elseif ($endTimestamp < $minDate || $endTimestamp > $maxDate) {
            echo '<p>Invalid date range. The end date should be within a minimum of 6 months and a maximum of 1 year from the start date.</p><br>
                <br><a href="create_agreement.php">Go Back</a>';
            exit;
        }


        // Prepare the SQL statement
        $sql = "INSERT INTO agreement (id, propertyid, rentername, renterhome#, renterwork#, startdate, enddate, deposit, monthlyrent)
                VALUES ((SELECT MAX(id) + 1 FROM agreement), :propertyId, :renterName, :renterHomePhone, :renterWorkPhone,
                        TO_DATE(:startDate, 'YYYY-MM-DD'), TO_DATE(:endDate, 'YYYY-MM-DD'), :deposit,
                        (SELECT monthlyrent FROM property WHERE id = :propertyId))";

        // Prepare the statement
        $stmt = oci_parse($conn, $sql);

        // Bind the parameters
        oci_bind_by_name($stmt, ':propertyId', $propertyId);
        oci_bind_by_name($stmt, ':renterName', $renterName);
        oci_bind_by_name($stmt, ':renterHomePhone', $renterHomePhone);
        oci_bind_by_name($stmt, ':renterWorkPhone', $renterWorkPhone);
        oci_bind_by_name($stmt, ':startDate', $startDate);
        oci_bind_by_name($stmt, ':endDate', $endDate);
        oci_bind_by_name($stmt, ':deposit', $deposit);

        // Execute the statement
        $success = oci_execute($stmt);

        if ($success) {
            echo '<p>New lease agreement created successfully!</p>';

            // Fetch and display the newly created agreement
            $agreementQuery = "SELECT * FROM agreement WHERE id = (SELECT MAX(id) FROM agreement)";
            $agreementStmt = oci_parse($conn, $agreementQuery);
            oci_execute($agreementStmt);

            echo '<h2>Newly Created Agreement:</h2>';
            echo '<table>
                    <tr>
                        <th>ID</th>
                        <th>Property ID</th>
                        <th>Renter Name</th>
                        <th>Renter Home Phone</th>
                        <th>Renter Work Phone</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Deposit</th>
                        <th>Monthly Rent</th>
                    </tr>';

            while ($row = oci_fetch_array($agreementStmt, OCI_ASSOC)) {
                echo '<tr>';
                foreach ($row as $value) {
                    echo '<td>' . $value . '</td>';
                }
            }
            echo '</table>';
            // Hide the form by setting a flag
            $hideForm = true;
        } else {
            echo '<p>Error creating lease agreement.</p>';
        }

        // Close the statement
        oci_free_statement($stmt);
    }
    // Check if the form should be hidden
    if (!isset($hideForm)) {
        // Display the form
        echo '
        <form method="POST" action="">
            <label for="property_id">Property ID:</label>
            <input type="text" name="property_id" required><br>

            <label for="renter_name">Renter Name:</label>
            <input type="text" name="renter_name" required><br>

            <label for="renter_home_phone">Renter Home Phone:</label>
            <input type="text" name="renter_home_phone" required><br>

            <label for="renter_work_phone">Renter Work Phone:</label>
            <input type="text" name="renter_work_phone" required><br>

            <label for="start_date">Start Date:</label>
            <input type="date" name="start_date" required><br>

            <label for="end_date">End Date:</label>
            <input type="date" name="end_date" required><br>

            <label for="deposit">Deposit Amount:</label>
            <input type="text" name="deposit" required><br>

            <input type="submit" value="Create Agreement">
        </form>';
    }

    // Close the connection
    oci_close($conn);
    ?>
    <br><a href="index.php">Main Menu</a>
</body>
</html>
