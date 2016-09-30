<?php
    $cert = "lib/borjan_pvt_ltd.pem";
    $pass = "Comtrust";

    $opts = array();

    $options = array(
      'trace' => 1,
      'keep_alive' => true,
      'exceptions' => 0,
      //'soap_version' => SOAP_1_1,
      'local_cert' => $cert,
      'passphrase' => $pass,
      'stream_context' => stream_context_create($opts),
      'cache_wsdl' => WSDL_CACHE_NONE

    );

    $customer = $argv[1];
    $transaction_id = $argv[2];

    $client = new SoapClient(" https://ipg.comtrust.ae/Payment/PaymentPortal.aspx?lang=en&layout=C0STCBVLEI
", $options);

    $params = array(
        'Finalize' => '',
        'request' => array(
        'Customer' => $customer,
        'Language' => 'en',
        'version' => 2,
        'TransactionID' => $transaction_id
        )
    );

    $result = $client->QueryTransaction($params);
    $encoded = json_encode($result);
    echo $encoded;
?>
