<?php

class Update {
    private $_key = '';
    private $_history_file = '';
    private $_data = array();

    public function __construct($key, $history_file = 'history.csv') {
        $this->_key = $key;
        $this->_history_file = $history_file;

        if( isset( $_GET[$key] ) ) self::write_to_csv( $_SERVER['REMOTE_ADDR'] );

    }

    /**
     * Write stuff to csv
     * @param  string $ip IP-address
     */
    private function write_to_csv( $ip ) {
        // Write headline if not existant
        if( !file_exists( $this->_history_file ) )
        {
            $this->_data[0] = array(
                'Date',
                'IP'
            );
        }

        // Write actual entry
        $this->_data[1] = array(
            date('d. M. H:i'),
            $ip
        );

        // Actually write data to file
        $handle = fopen($this->_history_file, 'a');
        foreach ($this->_data as $key => $line) {
            fputcsv($handle, $line);
        }
        fclose($handle);
    }
}

new Update('onecrazykeyasdasd12351asldkj19');
?>
