<?php
    $email = isset($_POST['email']) ? $_POST['email'] : '';
    $tkn = isset($_POST['tkn']) ? $_POST['tkn'] : '';
    $z = isset($_POST['z']) ? $_POST['z'] : '';
?>
<!DOCTYPE html>
<html>
    <body>
        <p>Fill in your data to get the id of the first a-record</p>
        <form action="." method="POST">
            <label for="email">E-Mail</label>
            <input type="email" name="email" id="email" placeholder="E-Mail" value="<?php echo $email; ?>" />
            <br />
            <label for="tkn">Token</label>
            <input type="text" name="tkn" id="tkn" placeholder="Token" value="<?php echo $tkn; ?>" />
            <br />
            <label for="z">Zone</label>
            <input type="text" name="z" id="z" placeholder="Domain" value="<?php echo $z; ?>" />
            <br />
            <input type="submit" value="Get ID" />
        </form>
<?php
    if( isset( $_POST['tkn'], $_POST['email'], $_POST['z'] ) ) {
        $data = array(
            'a' => 'rec_load_all',
            'tkn' => $_POST['tkn'],
            'email' => $_POST['email'],
            'z' => $_POST['z']
        );

        $ch = curl_init();
        curl_setopt_array($ch, array(
            CURLOPT_URL => 'https://www.cloudflare.com/api_json.html',
            CURLOPT_PORT => '443',
            CURLOPT_RETURNTRANSFER => 1,
            CURLOPT_POST => 1,
            CURLOPT_POSTFIELDS => $data
        ) );

        $result = json_decode( curl_exec( $ch ), 1 );

        header('Content-type:text/plain;charset=utf-8');
        if( $result['result'] == 'error' ) {
            echo '<p style="color:red;">' . $result['msg'] . '</p>';
        } else {
            foreach( $result['response']['recs']['objs'] as $key => $rec ) {
                if( $rec['type'] == 'A' && $rec['name'] == $data['z'] ) {
                    echo '<p style="color:green;">Your token: <input type="text" readonly value="' . $rec['rec_id'] . '"/></p>';
                }
            }
        }
    }
?>
    </body>
</html>
